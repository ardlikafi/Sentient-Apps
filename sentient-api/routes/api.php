<?php

use App\Http\Controllers\AuthController;

Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::middleware('auth:api')->get('profile', [AuthController::class, 'profile']);
Route::post('profile/avatar', [AuthController::class, 'updateAvatar'])->middleware('auth:api'); 