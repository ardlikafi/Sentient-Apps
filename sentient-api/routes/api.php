<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\CourseController;

Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::get('profile', [AuthController::class, 'profile']);
Route::post('profile/avatar', [AuthController::class, 'updateAvatar']);
Route::get('public-courses', [CourseController::class, 'publicIndex']);
