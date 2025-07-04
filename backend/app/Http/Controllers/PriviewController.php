<?php

namespace App\Http\Controllers;

use App\Models\Priview;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class PriviewController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $priview = Priview::all();
        return response()->json($priview);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
         $validated = $request->validate([
            'user_id' => 'required|exists:users,id',
            'product_id' => 'required|exists:products,id',
            'rating' => 'required|numeric',
            'comment' => 'required|string|max:255',
         ]);
         $priview = Priview::create($validated);
         return response()->json($priview);
    }

    /**
     * Display the specified resource.
     */
    public function show(Priview $priview)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Priview $priview)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Priview $priview)
    {
        //
    }
}
