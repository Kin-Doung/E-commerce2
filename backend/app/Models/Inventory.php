<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Inventory extends Model
{
    use HasFactory;
    protected $fillable = [
        'product_id',
        'stock_id',
        'quantity',
    ];
    public function products(){
        return $this->belongsToMany(Product::class);
    }
    public function stocks(){
        return $this->belongsTo(Stock::class);
    }
}
