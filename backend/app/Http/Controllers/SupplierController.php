<?php

namespace App\Http\Controllers;

use App\Models\Supplier;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Supplier\SupplierStoreResquest;
use App\Http\Requests\Supplier\SupplierUpdateResquest;


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
    public function store(SupplierStoreResquest $request)
    {
       $validated = $request->validated();

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

    public function update(SupplierUpdateResquest $request, String $id)
    {
        $validated = $request->validated();

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
