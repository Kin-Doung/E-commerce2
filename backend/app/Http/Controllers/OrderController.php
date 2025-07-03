<?php

namespace App\Http\Controllers;

use App\Models\Order;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $orders = Order::with(['users', 'orderItem', 'payments'])->get();

        $orders->each(function ($order) {
            $order->calculated_total = $order->orderItem->sum('total');
        });

        return response()->json($orders);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'address_id' => 'nullable|exists:addresses,id',
        ]);

        $order = Order::create([
            'user_id' => $validated['user_id'],
            'address_id' => $validated['address_id'] ?? null,
            'total' => 0
        ]);

        return response()->json([
            'message' => 'Order created successfully',
            'order' => $order
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $order = Order::with(['user', 'orderItems'])->findOrFail($id);
        $order->calculated_total = $order->orderItems->sum('total');

        return response()->json($order);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $validated = $request->validate([
            'user_id' => 'sometimes|exists:users,id',
            'address_id' => 'nullable|exists:addresses,id',
        ]);

        $order = Order::findOrFail($id);

        if (isset($validated['user_id'])) {
            $order->user_id = $validated['user_id'];
        }

        if (array_key_exists('address_id', $validated)) {
            $order->address_id = $validated['address_id'];
        }

        // Recalculate total
        $order->total = $order->orderItems()->sum('total');

        $order->save();

        return response()->json([
            'message' => 'Order updated successfully',
            'order' => $order
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $order = Order::findOrFail($id);
        $order->delete();

        return response()->json([
            'message' => 'Order deleted successfully'
        ]);
    }
}
