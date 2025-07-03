<?php

namespace App\Http\Controllers;

use App\Models\Supplier;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class SupplierController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $suppliers = Supplier::all();
        return response()->json($suppliers);
    }
    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name'         => 'required|string|max:255',
            'contact_info' => 'required|string|max:255',
            'address_id'   => 'required|exists:addresses,id',
        ]);

        $suppliers = Supplier::create($validated);

        return response()->json([
            'message' => 'Supplier created successfully.',
            'data'    => $suppliers,
        ], 201);
    }


    /**
     * Display the specified resource.
     */
    public function show(String $id)
    {
        $suppliers = Supplier::findOrFail($id);
        return response()->json($suppliers);
    }

    public function update(Request $request, String $id)
    {
        $validated = $request->validate([
            'name'         => 'required|string|max:255',
            'contact_info' => 'required|string|max:255',
            'address_id'   => 'required|exists:addresses,id',
        ]);

        $supplier = Supplier::findOrFail($id);
        $supplier->update($validated);

        return response()->json([
            'message' => 'Supplier updated successfully.',
            'data'    => $supplier,
        ]);
    }


    public function destroy(String $id)
    {
        $suppliers = Supplier::findOrFail($id);
        $suppliers->delete();
        return response()->json(['message' => 'category deleted succ']);
    }
}
