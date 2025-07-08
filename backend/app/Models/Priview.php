<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Priview extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'product_id',
        'rating',
        'comment',
    ];
    public function users(){
        return $this->belongsTo(User::class);
    }
    public function products(){
        return $this->belongsTo(Product::class);
    }
        public function getCreatedAtAttribute($value) {
        return date('d-m-Y', strtotime($value));
    }

    // create attribute to clean date formate
    public function getUpdatedAtAttribute($value) {
        return date('F d, Y', strtotime($value));
    }
}
