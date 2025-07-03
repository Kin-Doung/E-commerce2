<?php

namespace App\Http\Controllers;

use App\Models\Order_Item;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Order;


class OrderItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $order_Item = Order_Item::all();
        return response()->json($order_Item);
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
        $order->total = $order->orderItems()->sum('total'); // ✅ must match your relation name
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
    public function show(Order_Item $order_Item)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Order_Item $order_Item)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order_Item $order_Item)
    {
        //
    }
}
