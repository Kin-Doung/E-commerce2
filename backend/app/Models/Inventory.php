<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Inventory extends Model
{
    use HasFactory;

    protected $fillable = [
        'stock_id',
        'product_id',
        'quantity',
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
