<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Carbon;

class Discount extends Model
{
    use HasFactory;
    protected $fillable = [
        'code',
        'discount_percentage',
    ];
    public function getUpdatedAtAttribute($value)
    {
        return Carbon::parse($value)->format('d-F-Y');
    }
    
}
