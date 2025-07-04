<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;
    protected $fillable = [
        'order_id',
        'amount',
    ];
    public function orders(){
        return $this->belongsTo(Order::class);  
    }
    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
