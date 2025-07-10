<?php

namespace App\Http\Controllers;

use App\Models\Inventory;
use Illuminate\Http\Request;

class InventoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        // Return all inventory records as JSON
        $inventories = Inventory::with(['stock', 'product'])->get();
        return response()->json($inventories);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validate the request
        $validated = $request->validate([
            'stock_id' => 'required|integer',
            'product_id' => 'required|integer',
            'quantity' => 'required|integer',
        ]);

        // Create new inventory record
        $inventory = Inventory::create($validated);

        return response()->json($inventory, 201); // 201 Created
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json(['message' => 'Not Found'], 404);
        }

        return response()->json($inventory);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json(['message' => 'Not Found'], 404);
        }

        // Validate the request
        $validated = $request->validate([
            'stock_id' => 'sometimes|integer',
            'product_id' => 'sometimes|integer',
            'quantity' => 'sometimes|integer',
        ]);

        $inventory->update($validated);

        return response()->json($inventory);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $inventory = Inventory::find($id);

        if (!$inventory) {
            return response()->json(['message' => 'Not Found'], 404);
        }

        $inventory->delete();

        return response()->json(['message' => 'Deleted']);
    }
    /**
     * Get the total quantity of all inventory records.
     */
    public function totalQuantity()
    {
        $total = Inventory::sum('quantity');
        return response()->json(['total_quantity' => $total]);
    }
}
