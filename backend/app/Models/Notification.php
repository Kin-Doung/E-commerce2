<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    use HasFactory;
    protected $fillable = [
        'message',
        'is_read',
        'user_id',
    ];
    public function users(){
        return $this->belongsTo(User::class);
    }
    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}
