<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Category extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'stock_id'];
    public function products()
    {
        return $this->hasMany(Product::class);
    }
    public function stock()
    {
        return $this->belongsTo(Stock::class);
    }
    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
