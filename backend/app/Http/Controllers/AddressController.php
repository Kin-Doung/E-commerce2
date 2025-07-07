<?php

namespace App\Http\Controllers;

use App\Models\Address;
use Illuminate\Http\Request;
use App\Http\Requests\Address\AddressUpdateResquest;
use App\Http\Requests\Address\AddressStoreRequest;

class AddressController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $addresses = Address::all();
        return response()->json($addresses);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(AddressStoreRequest $request)
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
    public function show(string $id)
    {
        $address = Address::findOrFail($id);
        return response()->json($address);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(AddressUpdateResquest $request, string $id)
    {
        $address = Address::findOrFail($id);
        $address->update($request->validated());
        return response()->json([
            'message' => 'Address updated successfully',
            'data' => $address,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $address = Address::findOrFail($id);
        $address->delete();

        return response()->json(['message' => 'Address deleted successfully']);
    }
}
