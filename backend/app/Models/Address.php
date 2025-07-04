<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Address extends Model
{
    use HasFactory;
    protected $fillable = [
        'line1',
        'city',
        'country',
        'user_id',
    ];
    public function users(){
        return $this->belongsTo(User::class);
    }
    public function orders(){
        return $this->hasMany(Order::class);
    }
    public function suppliers(){
        return $this->hasMany(Supplier::class);
    }

    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
