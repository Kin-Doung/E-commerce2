<?php

namespace App\Http\Controllers;

use App\Models\Stock;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Stock\StockUpdateResquest;
use App\Http\Requests\Stock\StockStoreRequest;

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
    public function store(StockStoreRequest $request)
    {
        $validated = $request->validated();
        $stock = Stock::create($validated);

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
        $stock = Stock::findOrFail($id);
        return response()->json($stock);
    }

    /**
     * Update the specified resource in storage.
     */
   public function update(StockUpdateResquest $request, string $id)
    {
        $stock = Stock::findOrFail($id);
        $validated = $request->validated();
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
            'message' => 'stock deletd succ',
        ]);
    }
}
