<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    use HasFactory;
    protected $fillable = [
        'product_name',
        'product_id',
        'quantity',
        'image',
        'category_id',
    ];
    public function category(){
        return $this->hasMany(Category::class);
    }
    public function inventory(){
        return $this->belongsTo(Inventory::class);
    }
}
