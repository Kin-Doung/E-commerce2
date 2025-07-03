<?php

namespace App\Http\Controllers;

use App\Models\Address;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

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
    public function store(Request $request)
    {
        $validated = $request->validate([
             'line1' => 'required|string|max:255',
             'city' => 'required|string|max:255',
             'country' => 'required|string|max:255',
            'user_id' => 'required|exists:users,id',
        ]);
        $address = Address::create($validated);
       return response()->json([
            'message' => 'succ',
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
    public function update(Request $request, String $id)
    {
        $address = Address::findOrFail($id);
         $validated = $request->validate([
             'line1' => 'required|string|max:255',
             'city' => 'required|string|max:255',
             'country' => 'required|string|max:255',
            'user_id' => 'required|exists:users,id',
        ]);
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
        return response()->json(['message'=>'address deleted succ']);

    }
}
