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
        //
        $preview = Priview::all();
        return response()->json($preview);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'user_id' => 'required|integger|exists:users,id',
            'product_id' => 'required|integer|exists:products,id',
            'rating' => 'required|integer|max:255',
            'cooment' => 'required|string|max:255',
        ]);
        $preview = Priview::create($validated);
        return response()->json([
            'Preview' => 'Review successfully',
            'preview' => $preview,
        ]);
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
