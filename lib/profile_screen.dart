import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  Map<String, dynamic>? profile;
  bool _loading = true;
  String? _error;
  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      setState(() {
        _error = 'Token tidak ditemukan. Silakan login ulang.';
        _loading = false;
      });
      return;
    }
    final result = await ApiService.getProfile(token);
    setState(() {
      _loading = false;
      if (result != null &&
          result['user'] != null &&
          result['profile'] != null) {
        user = result['user'];
        profile = result['profile'];
      } else {
        _error = 'Gagal mengambil data profile.';
      }
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
      // Upload ke backend
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final avatarPath = await ApiService.uploadAvatar(
          token: token,
          avatar: _profileImageFile!,
        );
        if (avatarPath != null) {
          // Fetch ulang profile agar UI sinkron
          await _fetchProfile();
        }
      }
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF07143B),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF07143B)),
                margin: EdgeInsets.only(bottom: 0),
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: Colors.white24, height: 1, thickness: 1),
              ),
              const SizedBox(height: 18),
              _drawerMenuItem(
                Icons.notifications_none_rounded,
                'Notifications',
              ),
              const SizedBox(height: 10),
              _drawerMenuItem(Icons.language, 'Language'),
              const SizedBox(height: 10),
              _drawerMenuItem(
                Icons.credit_card,
                'Subscription & Billing',
                icon2: Icons.star,
                icon2Color: Color(0xFFF7B801),
              ),
              const SizedBox(height: 10),
              _drawerMenuItem(Icons.security, 'Privacy & Security'),
              const SizedBox(height: 10),
              _drawerMenuItem(Icons.help_outline, 'Help & Support'),
              const SizedBox(height: 10),
              _drawerMenuItem(
                Icons.info_outline,
                'About the App',
                italic: true,
              ),
              const SizedBox(height: 80), // Spacer for logout
            ],
          ),
          // Logout sticky di bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A1128),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: _logout,
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerMenuItem(
    IconData icon,
    String title, {
    IconData? icon2,
    Color? icon2Color,
    bool italic = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          if (icon2 != null) ...[
            const SizedBox(width: 2),
            Icon(icon2, color: icon2Color ?? Colors.white, size: 16),
          ],
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      backgroundColor: const Color(0xFFE3F0FF),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Custom Header mirip Shop
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 40,
                        left: 0,
                        right: 0,
                        bottom: 20,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF07143B), Color(0xFF0A1128)],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Builder(
                                builder:
                                    (context) => IconButton(
                                      icon: const Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                    ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(height: 0),
                          const Text(
                            'Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Manage your account & settings',
                            style: TextStyle(
                              color: Color(0xFFB3D6F6),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Header profile (foto, nama, email)
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Foto profil editable
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    _profileImageFile != null
                                        ? FileImage(_profileImageFile!)
                                        : (profile?['avatar'] != null &&
                                            profile!['avatar']
                                                .toString()
                                                .isNotEmpty)
                                        ? NetworkImage(
                                          profile!['avatar']
                                                  .toString()
                                                  .startsWith('http')
                                              ? profile!['avatar']
                                              : 'http://192.168.1.19:8000/storage/${profile!['avatar']}',
                                        )
                                        : null as ImageProvider<Object>?,
                                child:
                                    (profile?['avatar'] == null ||
                                                profile!['avatar']
                                                    .toString()
                                                    .isEmpty) &&
                                            _profileImageFile == null
                                        ? const Icon(
                                          Icons.person,
                                          size: 48,
                                          color: Color(0xFF07143B),
                                        )
                                        : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3576F6),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profile?['username'] ?? '-',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF07143B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user?['email'] ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Subscription Card (mirip desain)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFD6E9FF),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.08),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Color(0xFFB3D6F6),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.workspace_premium,
                                    color: Color(0xFF3576F6),
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Premium',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF07143B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Color(0xFF3576F6),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Active until: June 20, 2025',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF07143B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: Color(0xFFF7B801),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Benefits:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF07143B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Padding(
                                padding: EdgeInsets.only(left: 28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• Unlimited access to all courses',
                                      style: TextStyle(
                                        color: Color(0xFF07143B),
                                      ),
                                    ),
                                    Text(
                                      '• Exclusive articles',
                                      style: TextStyle(
                                        color: Color(0xFF07143B),
                                      ),
                                    ),
                                    Text(
                                      '• Special discounts in the shop',
                                      style: TextStyle(
                                        color: Color(0xFF07143B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF3576F6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.flash_on,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Renew Subscription',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Account Settings (dummy)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF3576F6),
                              ),
                              title: const Text('Account Information'),
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF3576F6),
                              ),
                              title: const Text('Security'),
                              onTap: () {},
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(
                                Icons.edit,
                                color: Color(0xFF3576F6),
                              ),
                              title: const Text('Edit Profile'),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Tombol Logout di bawah halaman profil (lebih bagus)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'LOGOUT',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A1128),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: const Color(
                              0xFF0A1128,
                            ).withOpacity(0.18),
                          ),
                          onPressed: _logout,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
    );
  }
}
