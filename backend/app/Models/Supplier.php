<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Supplier extends Model
{
    use HasFactory;
    protected $fillable = [
        'name',
        'contact_info',
        'address_id',
    ];
    public function suppliers(){
        return $this->belongsTo(Address::class);
    }
    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
