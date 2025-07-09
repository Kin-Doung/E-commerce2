<?php

namespace App\Http\Controllers;

use App\Models\Stock;
use App\Models\Category;
use App\Models\Inventory;
use Illuminate\Http\Request;

class StockController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $stock = Stock::with('category', 'inventory')->get();
        return response()->json($stock);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'quantity' => 'required|numeric|min:0',
            'category_id' => 'nullable|exists:categories,id',
        ]);

        $stock = Stock::create($request->all());

        return response()->json([
            'message' => 'Stock created successfully',
            'data' => $stock
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $stock = Stock::with('category', 'inventory')->findOrFail($id);
        return response()->json($stock);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $stock = Stock::findOrFail($id);

        $validated = $request->validate([
            'name' => 'string|max:255',
            'quantity' => 'numeric|min:0',
            'category_id' => 'nullable|exists:categories,id',
        ]);

        $stock->update($validated);

        return response()->json([
            'message' => 'Stock updated successfully',
            'data' => $stock
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $stock = Stock::findOrFail($id);
        $stock->delete();

        return response()->json([
            'message' => 'Stock deleted successfully',
        ]);
    }

    /**
     * Calculate and return the total quantity of all inventory items.
     */
    public function totalQuantity()
    {
        $total = Inventory::sum('quantity');
        return response()->json(['total_quantity' => (int) $total]);
    }
}