<?php

namespace App\Http\Controllers;

use App\Models\Order_Item;
use App\Models\Order;
use Illuminate\Http\Request;

class OrderItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $orderItems = Order_Item::all();
        return response()->json($orderItems);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'order_id' => 'required|exists:orders,id',
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
            'price' => 'required|numeric|min:0',
        ]);

        // Calculate total
        $validated['total'] = $validated['price'] * $validated['quantity'];

        // Create the order item
        $orderItem = Order_Item::create($validated);

        // Update parent order's total
        $order = Order::findOrFail($validated['order_id']);
        $order->total = $order->orderItems()->sum('total');
        $order->save();

        return response()->json([
            'message' => 'Order item created and order total updated',
            'order_item' => $orderItem,
            'order' => $order,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $orderItem = Order_Item::findOrFail($id);
        return response()->json($orderItem);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $orderItem = Order_Item::findOrFail($id);

        $validated = $request->validate([
            'quantity' => 'sometimes|integer|min:1',
            'price' => 'sometimes|numeric|min:0',
        ]);

        if (isset($validated['quantity'])) {
            $orderItem->quantity = $validated['quantity'];
        }

        if (isset($validated['price'])) {
            $orderItem->price = $validated['price'];
        }

        // Recalculate total
        $orderItem->total = $orderItem->quantity * $orderItem->price;

        $orderItem->save();

        // Update parent order total
        $order = Order::findOrFail($orderItem->order_id);
        $order->total = $order->orderItems()->sum('total');
        $order->save();

        return response()->json([
            'message' => 'Order item updated and order total recalculated',
            'order_item' => $orderItem,
            'order' => $order,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $orderItem = Order_Item::findOrFail($id);
        $orderId = $orderItem->order_id;

        $orderItem->delete();

        // Update parent order total
        $order = Order::findOrFail($orderId);
        $order->total = $order->orderItems()->sum('total');
        $order->save();

        return response()->json([
            'message' => 'Order item deleted and order total recalculated',
            'order' => $order,
        ]);
    }
}
