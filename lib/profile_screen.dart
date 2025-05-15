import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      backgroundColor: const Color(0xFF07143B),
      body: Center(
        child:
            _loading
                ? const CircularProgressIndicator()
                : _error != null
                ? Text(_error!, style: const TextStyle(color: Colors.red))
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (profile?['avatar'] != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(profile!['avatar']),
                        radius: 40,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      user?['name'] ?? '-',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user?['email'] ?? '-',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '@${profile?['username'] ?? '-'}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      profile?['bio'] ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
      ),
    );
  }
}
