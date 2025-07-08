<?php

namespace App\Http\Controllers;

use App\Models\Preview;
use Illuminate\Http\Request;
use App\Http\Requests\Preview\PreviewStoreResquest;
use App\Http\Requests\Preview\PreviewUpdateRequest;

class PriviewController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $previews = Preview::all();
        return response()->json($previews);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(PreviewStoreResquest $request)
    {
        $validated = $request->validated();

        $preview = Preview::create($validated);

        return response()->json($preview);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $preview = Preview::findOrFail($id);
        return response()->json($preview);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(PreviewUpdateRequest $request, string $id)
    {
        $validated = $request->validated();

        $preview = Preview::findOrFail($id);
        $preview->update($validated);

        return response()->json([
            'message' => 'Preview successfully updated.',
            'preview' => $preview,
        ]);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Preview $preview)
    {
        $preview->delete();

        return response()->json([
            'message' => 'Preview successfully deleted.',
        ]);
    }
}
