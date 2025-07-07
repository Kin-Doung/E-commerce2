<?php

namespace App\Http\Requests\Address;

use Illuminate\Foundation\Http\FormRequest;

<<<<<<< HEAD:backend/app/Http/Requests/Address/AddressStoreResquest.php
class AddressStoreResquest extends FormRequest
=======
class AddressStoreRequest extends FormRequest
>>>>>>> fc7ea194b57214bc1ae82cdf8038f95f9fae9ddb:backend/app/Http/Requests/Address/AddressStoreRequest.php
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
            'line1' => 'required|string|max:255',
             'city' => 'required|string|max:255',
             'country' => 'required|string|max:255',
            'user_id' => 'required|exists:users,id',
        ];
    }
}
