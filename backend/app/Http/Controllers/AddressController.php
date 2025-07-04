<?php

namespace App\Http\Controllers;

use App\Models\Address;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\Address\AddressUpdateResquest;



class AddressController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $address = Address::all();
        return response()->json($address);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(AddressStoreResquest $request)
    {
        $address = Address::create($request->validated());

        return response()->json([
            'message' => 'Address created successfully',
            'data' => $address,
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(String $id)
    {
        $address = Address::findOrFail($id);
        return response()->json($address);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(AddressUpdateResquest $request, String $id)
    {
        $address = Address::findOrFail($id);
        $validated = $request->validate();
        $address->update($validated);
        return response()->json($address);

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(String $id)
    {
        $address = Address::findOrFail($id);
        $address->delete();
        return response()->json(['message' => 'address deleted succ']);
    }
}
