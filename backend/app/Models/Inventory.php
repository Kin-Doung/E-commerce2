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
    public function product()
    {
        return $this->belongsTo(Product::class);
    }
    public function stock()
    {
        return $this->belongsTo(Stock::class);  
    }
        public function getCreatedAtAttribute($value) {
        return date('d-m-Y', strtotime($value));
    }

    // create attribute to clean date formate
    public function getUpdatedAtAttribute($value) {
        return date('F d, Y', strtotime($value));
    }
}
