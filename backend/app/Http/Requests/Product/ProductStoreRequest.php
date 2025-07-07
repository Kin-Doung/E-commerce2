<?php

namespace App\Http\Requests\Product;

use Illuminate\Foundation\Http\FormRequest;

<<<<<<< HEAD:backend/app/Http/Requests/Product/ProductStoreResquest.php
class ProductStoreResquest extends FormRequest
=======
class ProductStoreRequest extends FormRequest
>>>>>>> fc7ea194b57214bc1ae82cdf8038f95f9fae9ddb:backend/app/Http/Requests/Product/ProductStoreRequest.php
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
            'description' => 'required|string|max:255',
            'price' => 'required|numeric|min:0',
            'image' => 'required|image|mimes:jpg,jpeg,png,gif,bmp|max:2048',
            'category_id' => 'required|exists:categories,id',
        ];
    }
}
