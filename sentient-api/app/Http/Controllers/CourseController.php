<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Course;

class CourseController extends Controller
{
    public function publicIndex()
    {
        $courses = Course::select('id', 'title', 'description', 'price', 'image_url')->where('status', 'active')->get();
        return response()->json([
            'success' => true,
            'courses' => $courses
        ]);
    }
}
