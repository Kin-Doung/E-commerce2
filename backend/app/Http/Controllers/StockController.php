<?php

namespace App\Http\Controllers;

use App\Models\Stock;
use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class StockController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $stock = Stock::all();
        return response()->json($stock);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'quantity' => 'required|numeric',
        ]);

        $stock = Stock::create($request->all());

        return response()->json([
            'message' => 'succ',
            'data' => $stock
        ], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $stock = Stock::findOrFail($id);
        return response()->json($stock);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        // Find the category or fail
        $category = Category::findOrFail($id);

        // Validate request data
        $validated = $request->validate([
            'name' => 'string',
            'stock_id' => 'integer',
        ]);

        // Update the category with validated data
        $category->update($validated);

        return response()->json($category);
    }



    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $stock = Stock::findOrFail($id);
        $stock->delete();
        return response()->json([
            'message' => 'stock deletd succ',
        ]);
    }
}
