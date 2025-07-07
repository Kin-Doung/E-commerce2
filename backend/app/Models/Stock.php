<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stock extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'quantity',
    ];
    public function category(){
        return $this->hasMany(Category::class);
    }
    public function inventory(){
        return $this->hasMany(Inventory::class);
    }
    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
