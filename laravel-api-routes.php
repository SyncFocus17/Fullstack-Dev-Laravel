<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

$categories = [
    ['id' => 1, 'name' => 'Inkomen', 'icon' => '💰'],
    ['id' => 2, 'name' => 'Uitgaven', 'icon' => '💸'],
    ['id' => 3, 'name' => 'Sparen', 'icon' => '🏦'],
];

// GET - Alle categorieën!
Route::get('/categories', function () use (&$categories) {
    return response()->json($categories);
});

// POST - Nieuwe categorie!
Route::post('/categories', function (Request $request) use (&$categories) {
    // Validatie
    $validated = $request->validate([
        'name' => 'required|string|min:2|max:50',
        'icon' => 'nullable|string|max:10',
    ]);

    $newId = count($categories) > 0 ? max(array_column($categories, 'id')) + 1 : 1;
    
    $newCategory = [
        'id' => $newId,
        'name' => $validated['name'],
        'icon' => $validated['icon'] ?? '📁',
    ];

    $categories[] = $newCategory;

    return response()->json($newCategory, 201);
});

Route::delete('/categories/{id}', function ($id) use (&$categories) {
    $index = array_search($id, array_column($categories, 'id'));
    
    if ($index === false) {
        return response()->json(['message' => 'Categorie niet gevonden'], 404);
    }

    array_splice($categories, $index, 1);
    
    return response()->json(['message' => 'Categorie verwijderd'], 200);
});
