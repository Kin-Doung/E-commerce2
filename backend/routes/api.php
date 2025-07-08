<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\StockController;
use App\Http\Controllers\CategoryController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\OrderController;
use App\Http\Controllers\OrderItemController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\AddressController;
use App\Http\Controllers\InventoryController;

use App\Http\Controllers\SupplierController;
use App\Http\Controllers\PriviewController;
use App\Http\Controllers\AuthController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Authentication routes
Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/register', [AuthController::class, 'register']);
Route::post('/auth/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

Route::apiResource('priviews', PriviewController::class);
Route::apiResource('users', UserController::class);
Route::apiResource('stocks', StockController::class);
Route::apiResource('categories', CategoryController::class);
Route::apiResource('orderitems', OrderItemController::class);
Route::apiResource('address', AddressController::class);

Route::apiResource('orders', OrderController::class);
Route::apiResource('products', ProductController::class);
Route::apiResource('inventories', InventoryController::class);
Route::apiResource('supplier', SupplierController::class);
Route::apiResource('priview', PriviewController::class);

Route::apiResource('inventories', InventoryController::class);
