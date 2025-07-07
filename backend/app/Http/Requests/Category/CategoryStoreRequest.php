<?php

namespace App\Http\Requests\Category;

use Illuminate\Foundation\Http\FormRequest;

<<<<<<< HEAD:backend/app/Http/Requests/Category/CategoryStoreResquest.php
class CategoryStoreResquest extends FormRequest
=======
class CategoryStoreRequest extends FormRequest
>>>>>>> fc7ea194b57214bc1ae82cdf8038f95f9fae9ddb:backend/app/Http/Requests/Category/CategoryStoreRequest.php
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
             'name' => 'required|string|max:255',
            'stock_id' => 'required|exists:stocks,id'
        ];
    }
}
