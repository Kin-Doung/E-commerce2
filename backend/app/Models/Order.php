<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    protected $fillable = [
        'total',
        'user_id',
        'address',
    ];
    public function users(){
        return $this->belongsTo(User::class);
    }
    public function address(){
        return $this->belongsTo(Address::class);
    }
    public function payments(){
        return $this->hasMany(Payment::class);
    }
    public function orderItem(){
        return $this->hasMany(Order_Item::class);
    }
}
