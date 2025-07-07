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
<<<<<<< HEAD
    public function stock()
    {
        return $this->belongsTo(Stock::class);
    }
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
=======

    protected $hidden = [
        'created_at',
        'updated_at',
    ];
>>>>>>> 28fb607d6f5ed2ffb44cc1ca640279ceb7aa6693
}
