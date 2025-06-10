<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CourseController;

Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::middleware('auth:api')->get('profile', [AuthController::class, 'profile']);
Route::post('profile/avatar', [AuthController::class, 'updateAvatar'])->middleware('auth:api');
Route::get('public-courses', [CourseController::class, 'publicIndex']); 