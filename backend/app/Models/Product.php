<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'description', 'price', 'image', 'category_id'];

    public function category()
    {
        return $this->belongsTo(Category::class);
    }
    public function priview()
    {
        return $this->hasMany(Priview::class);
    }
    public function orderItem()
    {
        return $this->hasMany(Product::class);
    }
    public function inventory()
    {
        return $this->belongsToMany(Inventory::class);
    }
    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
