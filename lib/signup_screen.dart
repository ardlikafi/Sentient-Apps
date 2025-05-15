import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'api_service.dart';
import 'animated_route.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  File? _profileImage;
  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage = await File(
        pickedFile.path,
      ).copy('${directory.path}/$fileName');
      setState(() {
        _profileImage = savedImage;
      });
    }
    Navigator.pop(context);
  }

  void _showPhotoPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: const Color(0xFFF5F2FF),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Profile Photo',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF3576F6),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.camera),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFE3D6FF),
                          radius: 32,
                          child: Image.asset(
                            'assets/icons/ic_take_photo.png',
                            height: 32,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Take a photo',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Color(0xFF3576F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFE3D6FF),
                          radius: 32,
                          child: Image.asset(
                            'assets/icons/ic_add_gallery.png',
                            height: 32,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Gallery',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Color(0xFF3576F6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF3576F6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ApiService.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
    );
    setState(() {
      _loading = false;
    });
    if (result != null && result['token'] != null) {
      // Sukses, bisa simpan token dan navigasi ke halaman profile/dashboard
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        _error = 'Register gagal. Pastikan data valid.';
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Proses pendaftaran
      // _profileImage berisi file foto profil jika ada
      Navigator.of(context).pushAndRemoveUntil(
        FadeRoute(page: const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000A26),
              Color(0xFF001759),
              Color(0xFF001E73),
              Color(0xFF00258C),
            ],
            stops: [0.0, 0.5, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: IconButton(
                  icon: Image.asset('assets/icons/ic_back.png', height: 32),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Profile Photo
                        Column(
                          children: [
                            GestureDetector(
                              onTap: _showPhotoPicker,
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFE3D6FF),
                                radius: 56,
                                child:
                                    _profileImage != null
                                        ? ClipOval(
                                          child: Image.file(
                                            _profileImage!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : Image.asset(
                                          'assets/icons/ic_add_photo.png',
                                          height: 72,
                                        ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Profile Photo',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3576F6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Email
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF3576F6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                validator:
                                    (v) =>
                                        v == null || !v.contains('@')
                                            ? 'Email tidak valid'
                                            : null,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFE3F0FF),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/icons/ic_email.png',
                                      height: 24,
                                    ),
                                  ),
                                  hintText: 'example@gmail.com',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Create a Password',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF3576F6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator:
                                    (v) =>
                                        v == null || v.length < 6
                                            ? 'Password minimal 6 karakter'
                                            : null,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFE3F0FF),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/icons/ic_password.png',
                                      height: 24,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF3576F6),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  hintText: '**************',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Username
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Username',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF3576F6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _usernameController,
                                validator:
                                    (v) =>
                                        v == null || v.isEmpty
                                            ? 'Username wajib diisi'
                                            : null,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFE3F0FF),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/icons/ic_user.png',
                                      height: 24,
                                    ),
                                  ),
                                  hintText: 'Username',
                                  hintStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A1128),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _loading ? null : _register,
                    child:
                        _loading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
