<?php

namespace App\Http\Controllers;

use App\Models\Order;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;


class OrderController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $orders = Order::with(['users'])->get();

        // Optional: add total sum calculated dynamically
        $orders->each(function ($order) {
            $order->calculated_total = $order->items->sum('total');
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

        // Create with total default 0
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
    public function show(Order $order)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Order $order)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Order $order)
    {
        //
    }
}
