<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Profile;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    // Register tanpa validasi
    public function register(Request $request)
    {
        $user = User::create([
            'username' => $request->username ?? 'user_' . time(),
            'email' => $request->email ?? 'user_' . time() . '@example.com',
            'password' => Hash::make($request->password ?? 'password123'),
        ]);

        $profile = Profile::create([
            'user_id' => $user->id,
            'username' => $user->username,
            'bio' => null,
            'avatar' => null,
        ]);

        // Token sederhana
        $token = base64_encode($user->id . '|' . time());

        return response()->json([
            'success' => true,
            'message' => 'Register berhasil',
            'user' => $user,
            'profile' => $profile,
            'token' => $token,
        ], 201);
    }

    // Login tanpa validasi
    public function login(Request $request)
    {
        // Cari user berdasarkan email atau buat baru jika tidak ada
        $user = User::where('email', $request->email)->first();

        if (!$user) {
            // Buat user baru jika tidak ditemukan
            $user = User::create([
                'username' => 'user_' . time(),
                'email' => $request->email,
                'password' => Hash::make($request->password ?? 'password123'),
            ]);

            $profile = Profile::create([
                'user_id' => $user->id,
                'username' => $user->username,
                'bio' => null,
                'avatar' => null,
            ]);
        } else {
            $profile = $user->profile;
        }

        // Token sederhana
        $token = base64_encode($user->id . '|' . time());

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'user' => $user,
            'profile' => $profile,
            'token' => $token,
        ]);
    }

    // Get profile (sementara tanpa auth)
    public function profile(Request $request)
    {
        $token = $request->header('Authorization');
        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak ditemukan'
            ], 401);
        }

        // Decode token sederhana
        $tokenData = explode('|', base64_decode(str_replace('Bearer ', '', $token)));
        $userId = $tokenData[0] ?? null;

        if (!$userId) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak valid'
            ], 401);
        }

        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'user' => $user,
            'profile' => $user->profile,
        ]);
    }

    // Update avatar (sementara tanpa auth)
    public function updateAvatar(Request $request)
    {
        $token = $request->header('Authorization');
        if (!$token) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak ditemukan'
            ], 401);
        }

        // Decode token sederhana
        $tokenData = explode('|', base64_decode(str_replace('Bearer ', '', $token)));
        $userId = $tokenData[0] ?? null;

        if (!$userId) {
            return response()->json([
                'success' => false,
                'message' => 'Token tidak valid'
            ], 401);
        }

        $user = User::find($userId);
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan'
            ], 404);
        }

        $profile = $user->profile;
        if ($request->hasFile('avatar')) {
            $avatarPath = $request->file('avatar')->store('avatars', 'public');
            $profile->avatar = $avatarPath;
            $profile->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'Avatar berhasil diupdate',
            'profile' => $profile,
        ]);
    }
}
