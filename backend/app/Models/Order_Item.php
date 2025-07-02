<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order_Item extends Model
{
    use HasFactory;
    protected $fillable = [
        'order_id',
        'product_id',
        'quantity',
        'price',
    ];
    public function products(){
        return $this->belongsTo(Product::class);
    }
    public function orders(){
        return $this->belongsTo(Order::class);
    }
}
