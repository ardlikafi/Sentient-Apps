import 'package:flutter/material.dart';
import 'dart:math'; // Untuk Random().nextInt() pada shuffle sederhana
import 'package:sentient/course_screen.dart';
import 'package:sentient/shop_screen.dart';
import 'package:sentient/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

// Definisikan color palette Anda
const Color kDarkBlue = Color(0xFF000A26);
const Color kPrimaryBlue = Color(0xFF0F52BA);
const Color kLightBlue = Color(0xFFA6C6D8);
const Color kVeryLightBlue = Color(0xFFD6E5F2);

// Warna untuk gradasi
const Color kGradientStartBlue = Color(0xFF000A26);
const Color kGradientEndBlue = Color(
  0xFF0A3D91,
); // Sedikit lebih terang untuk gradasi

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState(); // Ini akan menjadi State BARU untuk HomeScreen
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Untuk melacak item navbar yang aktif

  // Daftar widget/halaman untuk setiap tab navbar
  static const List<Widget> _pageOptions = <Widget>[
    const HomeContent(), // Konten utama tab Home
    const CourseScreen(),
    const ShopScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body akan menampilkan halaman yang sesuai dengan _selectedIndex
      body: IndexedStack(
        // Menggunakan IndexedStack untuk menjaga state setiap halaman
        index: _selectedIndex,
        children: _pageOptions,
      ),
      bottomNavigationBar: Container(
        // Bungkus dengan Container untuk kontrol lebih
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: kDarkBlue, // Warna background utama navbar
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            // Opsional: tambahkan shadow jika diinginkan
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, -2), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          // Tetap gunakan ClipRRect untuk border radius pada kontennya
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined),
                activeIcon: Icon(Icons.menu_book),
                label: 'Course',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store_outlined),
                activeIcon: Icon(Icons.store),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: kVeryLightBlue,
            unselectedItemColor: kLightBlue.withOpacity(0.7),
            backgroundColor:
                Colors
                    .transparent, // Jadikan transparan karena Container sudah punya warna
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
            elevation:
                0, // Hapus elevation default karena Container sudah punya shadow
            iconSize: 26, // SEDIKIT TAMBAH UKURAN IKON
            selectedFontSize: 13, // SEDIKIT TAMBAH UKURAN FONT LABEL AKTIF
            unselectedFontSize: 12, // Ukuran font label tidak aktif
            // Anda bisa mencoba menambahkan padding pada item jika didukung
            // atau menyesuaikan tinggi keseluruhan dengan SizedBox jika perlu.
            // Untuk menambah tinggi secara visual, kita juga bisa menambah padding pada Container pembungkus:
            // Padding(
            //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0), // Tambah padding atas bawah
            //   child: BottomNavigationBar(...),
            // )
            // Namun, ini akan menambah padding di dalam area item, bukan memperbesar bar itu sendiri.
            // Solusi terbaik adalah membiarkan BottomNavigationBar mengatur tingginya
            // berdasarkan kontennya (ikon dan label).
          ),
        ),
      ),
    );
  }
}

// 3. Buat Widget HomeContent (StatelessWidget)
// Widget ini akan berisi semua UI yang sebelumnya ada di build method HomeScreen Anda
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // State untuk menyimpan data dari setiap section
  Map<String, dynamic>? _homeHeaderData;
  List<Map<String, String>> _eventDataList = [];
  List<Map<String, dynamic>> _allCourses = [];
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _allArticles = [];

  bool _isLoading = true; // Tambahkan state loading
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      await _fetchHomeHeaderData();
      await _fetchEventData();
      await _fetchCourseData();
      await _fetchShopData();
      await _fetchArticleData();
    } catch (e, s) {
      print('Error saat fetch data Home: $e\n$s');
      setState(() {
        _errorMsg = 'Terjadi error saat mengambil data Home: $e';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Fungsi untuk refresh data (dipanggil oleh RefreshIndicator)
  Future<void> _refreshData() async {
    await _fetchHomeHeaderData();
    await _fetchEventData();
    await _fetchCourseData();
    await _fetchShopData();
    await _fetchArticleData();
  }

  // TODO: Implementasi _fetchHomeHeaderData, _fetchEventData, _fetchCourseData, _fetchShopData, _fetchArticleData
  // Pindahkan logika fetch dari masing-masing widget section ke sini
  Future<void> _fetchHomeHeaderData() async {
    print('Mulai fetch profile...');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        setState(() {
          _errorMsg = 'Token tidak ditemukan. Silakan login ulang.';
        });
        print('Token tidak ditemukan.');
        return;
      }
      final result = await ApiService.getProfile(token);
      if (result != null) {
        setState(() {
          _homeHeaderData = result;
        });
        print('Profile berhasil diambil.');
      } else {
        setState(() {
          _errorMsg = 'Gagal mengambil data profile.';
        });
        print('Gagal mengambil data profile.');
      }
    } catch (e) {
      print('Error fetch profile: $e');
      setState(() {
        _errorMsg = 'Error fetch profile: $e';
      });
    }
  }

  Future<void> _fetchEventData() async {
    print('Mulai fetch event...');
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final random = Random();
      final eventDataList = [
        {
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/master_player/2977088e-fa8f-11e8-8015-45809e972e89.15c6cec0.250x250o.a30076060f1c.jpeg",
          "title": "Studi With Hikaru",
          "subtitle": "Only \$4",
          "buttonText": "Get Now",
        },
        {
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/master_player/2cfc1a6e-fa91-11e8-ac01-612003459e84.26451769.250x250o.f547f83363d0.jpeg",
          "title": "Masterclass with Magnus",
          "subtitle": "Limited Seats!",
          "buttonText": "Join Now",
        },
        {
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/user/30479874.2a7c9449.200x200o.b850d6093554.jpeg",
          "title": "GothamChess Bootcamp",
          "subtitle": "Become a Chess Bruh",
          "buttonText": "Buy",
        },
      ];
      setState(() {
        _eventDataList = [eventDataList[random.nextInt(eventDataList.length)]];
      });
      print('Event berhasil diambil.');
    } catch (e) {
      print('Error fetch event: $e');
      setState(() {
        _errorMsg = 'Error fetch event: $e';
      });
    }
  }

  Future<void> _fetchCourseData() async {
    print('Mulai fetch course...');
    try {
      await Future.delayed(Duration(milliseconds: 300));
      _allCourses = [
        {
          "id": "c1",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/PedroPinhata/phpZ1gGZl.png",
          "title": "Mastering Chess Fundamentals",
          "price": 100000,
          "rating": 4.5,
          "reviewCount": 50,
          "category": "popular",
        },
        {
          "id": "c2",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/PedroPinhata/phptgzgoK.png",
          "title": "Tactical Patterns & Strategy",
          "price": 270000,
          "rating": 4.8,
          "reviewCount": 75,
          "category": "popular",
        },
        {
          "id": "c3",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/PedroPinhata/phpFMn7gD.png",
          "title": "Opening Repertoire for All Levels",
          "price": 400000,
          "rating": 4.2,
          "reviewCount": 30,
          "category": "all",
        },
        {
          "id": "c4",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/PedroPinhata/php2EXLDO.png",
          "title": "Free Basic Chess Rules",
          "price": 0,
          "rating": 4.0,
          "reviewCount": 120,
          "category": "free",
        },
        {
          "id": "c5",
          "imageUrl":
              "https://www.chess.com/utility/images/share/L2NoZXNzLW9wZW5pbmdzLw,,.png",
          "title": "Advanced Endgame Techniques",
          "price": 350000,
          "rating": 4.9,
          "reviewCount": 90,
          "category": "popular",
        },
      ];
      setState(() {});
      print('Course berhasil diambil.');
    } catch (e) {
      print('Error fetch course: $e');
      setState(() {
        _errorMsg = 'Error fetch course: $e';
      });
    }
  }

  Future<void> _fetchShopData() async {
    print('Mulai fetch shop...');
    try {
      await Future.delayed(Duration(milliseconds: 300));
      _allProducts = [
        {
          "id": "p1",
          "imageUrl":
              "https://m.media-amazon.com/images/I/71zVVEVB5tL._AC_SL1500_.jpg",
          "name": "Beautiful Metal Chess Set",
          "price": 99.00,
          "category": "chess",
        },
        {
          "id": "p2",
          "imageUrl":
              "https://m.media-amazon.com/images/I/81M7o+-V3CL._AC_SL1500_.jpg",
          "name": "Beautiful Handcrafted Wooden Chess Set",
          "price": 99.00,
          "category": "chess",
        },
        {
          "id": "p3",
          "imageUrl":
              "https://m.media-amazon.com/images/I/71v5Xyol6qL._AC_SL1500_.jpg",
          "name": "Elegant Glass Chess Set",
          "price": 99.00,
          "category": "chess",
        },
        {
          "id": "p4",
          "imageUrl":
              "https://m.media-amazon.com/images/I/71UohSAT3DL._AC_SL1500_.jpg",
          "name": "Luxurious Marble Chess Set",
          "price": 99.00,
          "category": "chess",
        },
        {
          "id": "p5",
          "imageUrl":
              "https://m.media-amazon.com/images/I/61O23yq4mDL._AC_SL1000_.jpg",
          "name": "Chess Clock Digital Timer",
          "price": 25.00,
          "category": "items",
        },
        {
          "id": "p6",
          "imageUrl":
              "https://m.media-amazon.com/images/I/71g7g9WnB2L._AC_SL1500_.jpg",
          "name": "Roll-Up Chess Board",
          "price": 15.00,
          "category": "items",
        },
      ];
      setState(() {});
      print('Shop berhasil diambil.');
    } catch (e) {
      print('Error fetch shop: $e');
      setState(() {
        _errorMsg = 'Error fetch shop: $e';
      });
    }
  }

  Future<void> _fetchArticleData() async {
    print('Mulai fetch article...');
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final random = Random();
      _allArticles = [
        {
          "id": "a1",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/PedroPinhata/phpY0h0bY.jpeg",
          "title":
              "Learn Chess with a Mind of Its Own: The Sentient Chess Tutor",
          "summary":
              "Master the fundamentals of chess through interactive lessons, guided practice, and personalized AI feedback.",
          "date": "Maret 16, 2025",
          "source": "Chess.com Blog",
        },
        {
          "id": "a2",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/article/26022.77233108.630x354o.4aad52961f70.jpeg",
          "title": "Top 5 Openings for Beginners",
          "summary":
              "Discover the most effective and easy-to-learn chess openings to start your games强.",
          "date": "Maret 10, 2025",
          "source": "Lichess Org",
        },
        {
          "id": "a3",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/SamCopeland/phpfoXLVf.png",
          "title": "Understanding Middlegame Pawn Structures",
          "summary":
              "A deep dive into how pawn structures can dictate your middlegame strategy and plans.",
          "date": "Maret 05, 2025",
          "source": "ChessBase News",
        },
        {
          "id": "a4",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/ColinStapczynski/phpu2Yd7y.jpeg",
          "title": "The Art of a Kingside Attack",
          "summary":
              "Learn key patterns and ideas for launching a successful attack on your opponent's king.",
          "date": "Februari 28, 2025",
          "source": "The Week in Chess",
        },
        {
          "id": "a5",
          "imageUrl":
              "https://images.chesscomfiles.com/uploads/v1/images_users/tiny_mce/PedroPinhata/phppEkvum.png",
          "title": "How to Analyze Your Chess Games",
          "summary":
              "Improve your chess by effectively analyzing your past games, identifying mistakes and good moves.",
          "date": "Februari 20, 2025",
          "source": "Chessable",
        },
        {
          "id": "a6",
          "imageUrl":
              "https://www.chess.com/chess-themes/images/banners/variant_atomic.jpg",
          "title": "Introduction to Chess Variants",
          "summary":
              "Explore fun and exciting chess variants like Crazyhouse, Bughouse, and Atomic chess.",
          "date": "Februari 15, 2025",
          "source": "Chess Variants Org",
        },
      ];
      setState(() {
        _allArticles = List.from(_allArticles)..shuffle(random);
        _allArticles = _allArticles.take(6).toList();
      });
      print('Article berhasil diambil.');
    } catch (e) {
      print('Error fetch article: $e');
      setState(() {
        _errorMsg = 'Error fetch article: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold di sini penting jika HomeContent memiliki AppBar sendiri atau background spesifik
    return Scaffold(
      backgroundColor: kVeryLightBlue,
      body: SafeArea(
        top: false,
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child:
                _isLoading
                    ? Container(
                      height:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          kToolbarHeight,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                    : (_errorMsg != null)
                    ? Container(
                      height:
                          MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom -
                          kToolbarHeight,
                      child: Center(
                        child: Text(
                          _errorMsg!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeader(profileData: _homeHeaderData),
                        EventSection(eventDataList: _eventDataList),
                        CoursesSection(allCourses: _allCourses),
                        const GamesSection(),
                        ShopSection(allProducts: _allProducts),
                        ArticleSection(allArticles: _allArticles),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

class HomeHeader extends StatefulWidget {
  final Map<String, dynamic>? profileData;

  const HomeHeader({super.key, required this.profileData});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String _greeting = "";
  String _username = "";
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _fetchProfile();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour >= 5 && hour < 12) {
        _greeting = "Good Morning";
      } else if (hour >= 12 && hour < 18) {
        _greeting = "Good Afternoon";
      } else {
        _greeting = "Good Evening";
      }
    });
  }

  Future<void> _fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final result = await ApiService.getProfile(token);
      if (result != null && result['profile'] != null) {
        setState(() {
          _username = result['profile']['username'] ?? '';
          final avatar = result['profile']['avatar'];
          if (avatar != null && avatar.toString().isNotEmpty) {
            _avatarUrl =
                avatar.toString().startsWith('http')
                    ? avatar
                    : 'http://${ApiService.serverIP}:${ApiService.serverPort}/storage/$avatar';
          } else {
            _avatarUrl = null;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        left: 20.0, // Tambah padding kiri/kanan
        right: 20.0,
        top: topPadding + 16.0, // Sesuaikan padding atas
        bottom: 20.0, // Sesuaikan padding bawah
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGradientStartBlue, kGradientEndBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Rata kiri-kanan
        children: [
          Row(
            // Bungkus foto profil dan teks dalam satu Row untuk alignment
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  color: Colors.green, // Warna border profile
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 24, // Ukuran avatar sedikit lebih besar
                  backgroundColor: kLightBlue,
                  backgroundImage:
                      _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                  child:
                      _avatarUrl == null
                          ? const Icon(
                            Icons.person,
                            color: kDarkBlue,
                            size: 24,
                          ) // Icon sesuai ukuran avatar
                          : null,
                ),
              ),
              const SizedBox(width: 14), // Sesuaikan jarak
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    // Row untuk greeting (tanpa refresh icon)
                    children: [
                      Text(
                        _greeting,
                        style: TextStyle(
                          color: kVeryLightBlue.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _username.isNotEmpty ? _username : 'User',
                    style: const TextStyle(
                      color: kVeryLightBlue,
                      fontSize: 18, // Ukuran font username
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
          Row(
            // Bungkus ikon chat dan notifikasi dalam satu Row
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  print("Chat button pressed");
                  // Aksi navigasi ke halaman chat
                },
                customBorder: const CircleBorder(),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ), // Sesuaikan jarak antar ikon
                  padding: const EdgeInsets.all(8.0), // Padding di dalam ikon
                  decoration: BoxDecoration(
                    color: kVeryLightBlue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: kVeryLightBlue,
                    size: 20, // Ukuran ikon
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  print("Notification button pressed");
                  // Aksi navigasi ke halaman notifikasi
                },
                customBorder: const CircleBorder(),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ), // Sesuaikan jarak antar ikon
                  padding: const EdgeInsets.all(8.0), // Padding di dalam ikon
                  decoration: BoxDecoration(
                    color: kVeryLightBlue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_none_outlined,
                    color: kVeryLightBlue,
                    size: 20, // Ukuran ikon
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EventSection extends StatefulWidget {
  final List<Map<String, String>> eventDataList;

  const EventSection({super.key, required this.eventDataList});

  @override
  State<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  late Map<String, String> _currentEvent;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _selectRandomEvent();
  }

  void _selectRandomEvent() {
    if (widget.eventDataList.isNotEmpty) {
      _currentEvent =
          widget.eventDataList[_random.nextInt(widget.eventDataList.length)];
    } else {
      _currentEvent = {}; // Handle jika data kosong
    }
  }

  @override
  void didUpdateWidget(covariant EventSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventDataList != widget.eventDataList) {
      _selectRandomEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentEvent.isEmpty)
      return const SizedBox.shrink(); // Jangan tampilkan jika data kosong

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        20.0,
        16.0,
        16.0,
      ), // Tambah padding atas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Event",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue,
                ),
              ),
              TextButton(
                onPressed: () {
                  print("See all events pressed");
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AllEventsScreen()));
                },
                child: Text(
                  "See all",
                  style: TextStyle(
                    color: kPrimaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              print("Event card tapped: ${_currentEvent['title']}");
              // Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(event: _currentEvent)));
            },
            child: Container(
              height: 150,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: kPrimaryBlue,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        _currentEvent['imageUrl']!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: kLightBlue.withOpacity(0.5),
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: kVeryLightBlue.withOpacity(0.7),
                                size: 40,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                kVeryLightBlue,
                              ),
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentEvent['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kVeryLightBlue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentEvent['subtitle']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: kVeryLightBlue.withOpacity(0.9),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            print(
                              "Button '${_currentEvent['buttonText']}' pressed for event: ${_currentEvent['title']}",
                            );
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailScreen(event: _currentEvent)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kVeryLightBlue,
                            foregroundColor: kPrimaryBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(_currentEvent['buttonText']!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoursesSection extends StatefulWidget {
  final List<Map<String, dynamic>> allCourses;

  const CoursesSection({super.key, required this.allCourses});

  @override
  State<CoursesSection> createState() => _CoursesSectionState();
}

class _CoursesSectionState extends State<CoursesSection> {
  String _selectedFilter = "All Course";
  List<Map<String, dynamic>> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == "All Course") {
        _filteredCourses = List.from(widget.allCourses);
      } else if (_selectedFilter == "Populer") {
        _filteredCourses =
            widget.allCourses
                .where(
                  (course) =>
                      course['rating'] >= 4.5 ||
                      course['category'] == 'popular',
                )
                .toList();
      } else if (_selectedFilter == "Free") {
        _filteredCourses =
            widget.allCourses.where((course) => course['price'] == 0).toList();
      }
    });
  }

  @override
  void didUpdateWidget(covariant CoursesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allCourses != widget.allCourses) {
      _applyFilter();
    }
  }

  Widget _buildFilterButton(String title) {
    bool isActive = _selectedFilter == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedFilter = title;
            _applyFilter();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? kPrimaryBlue : kVeryLightBlue,
          foregroundColor: isActive ? kVeryLightBlue : kPrimaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isActive ? kPrimaryBlue : kLightBlue,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: isActive ? 2 : 0,
        ),
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ), // Padding atas dan bawah
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Judul "Courses" dan "See all"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Courses",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("See all courses pressed");
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AllCoursesScreen()));
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Baris Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              // Agar filter bisa di-scroll jika banyak
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("All Course"),
                  _buildFilterButton("Populer"),
                  _buildFilterButton("Free"),
                  // Tambahkan filter lain jika ada
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Daftar Course (Horizontal Scroll)
          SizedBox(
            height: 250, // Tinggi area daftar course, sesuaikan
            child:
                _filteredCourses.isEmpty
                    ? Center(
                      child: Text(
                        "No courses found for '$_selectedFilter'",
                        style: TextStyle(color: kDarkBlue.withOpacity(0.7)),
                      ),
                    )
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ), // Padding untuk item pertama dan terakhir
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];
                        return CourseCard(course: course);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Format harga
    // final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    // Untuk menggunakan NumberFormat, tambahkan `intl` ke pubspec.yaml jika belum ada
    // import 'package:intl/intl.dart';

    return GestureDetector(
      onTap: () {
        print("Course tapped: ${course['title']}");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailScreen(course: course)));
      },
      child: Container(
        width: 160, // Lebar setiap kartu course, sesuaikan
        margin: const EdgeInsets.only(right: 12.0), // Jarak antar kartu
        decoration: BoxDecoration(
          color: Colors.white, // Warna background kartu
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: kLightBlue.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Course
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Image.network(
                course['imageUrl']!,
                height: 120, // Tinggi gambar, sesuaikan
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: kLightBlue.withOpacity(0.3),
                    child: Center(
                      child: Icon(
                        Icons.photo_size_select_actual_outlined,
                        color: kDarkBlue.withOpacity(0.5),
                        size: 30,
                      ),
                    ),
                  );
                },
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryBlue),
                        strokeWidth: 2.0,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Detail Course (Judul, Harga, Rating)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kDarkBlue,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    course['price'] == 0
                        ? "Free"
                        : "Rp. ${course['price']}", // Tampilkan "Free" jika harga 0
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${course['rating']} (${course['reviewCount']})",
                        style: TextStyle(
                          fontSize: 12,
                          color: kDarkBlue.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GamesSection extends StatelessWidget {
  const GamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Padding untuk keseluruhan section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul "Games"
          Text(
            "Games",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkBlue,
            ),
          ),
          const SizedBox(height: 16), // Jarak antara judul dan tombol
          // Tombol "Coming Soon"
          Center(
            // Agar tombol berada di tengah section
            child: Container(
              width: double.infinity, // Lebar tombol memenuhi container
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ), // Padding vertikal tombol
              decoration: BoxDecoration(
                color: kPrimaryBlue, // Warna background tombol
                borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
                boxShadow: [
                  BoxShadow(
                    color: kDarkBlue.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                "COMING SOON",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kVeryLightBlue, // Warna teks tombol
                  letterSpacing: 1.5, // Sedikit spasi antar huruf
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopSection extends StatefulWidget {
  final List<Map<String, dynamic>> allProducts;

  const ShopSection({super.key, required this.allProducts});

  @override
  State<ShopSection> createState() => _ShopSectionState();
}

class _ShopSectionState extends State<ShopSection> {
  String _selectedFilter = "All Product";
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _applyFilter() {
    setState(() {
      if (_selectedFilter == "All Product") {
        _filteredProducts = List.from(widget.allProducts);
      } else if (_selectedFilter == "Chess") {
        _filteredProducts =
            widget.allProducts
                .where((product) => product['category'] == 'chess')
                .toList();
      } else if (_selectedFilter == "Items") {
        _filteredProducts =
            widget.allProducts
                .where((product) => product['category'] == 'items')
                .toList();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ShopSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allProducts != widget.allProducts) {
      _applyFilter();
    }
  }

  Widget _buildFilterButton(String title) {
    bool isActive = _selectedFilter == title;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedFilter = title;
            _applyFilter();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isActive ? kPrimaryBlue : kLightBlue.withOpacity(0.7),
          foregroundColor:
              isActive ? kVeryLightBlue : kDarkBlue.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: isActive ? 2 : 0,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan jumlah produk yang akan ditampilkan (misalnya 4 teratas atau semua yang difilter)
    // Untuk contoh ini, kita batasi agar tidak terlalu panjang di home, bisa diganti jadi semua
    final displayedProducts = _filteredProducts.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Judul "Shop" dan "See all"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Shop",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlue,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("See all products pressed");
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => AllProductsScreen()));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Baris Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("All Product"),
                  _buildFilterButton("Chess"),
                  _buildFilterButton("Items"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Daftar Produk (GridView)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                displayedProducts.isEmpty
                    ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "No products found for '$_selectedFilter'",
                          style: TextStyle(color: kDarkBlue.withOpacity(0.7)),
                        ),
                      ),
                    )
                    : GridView.builder(
                      shrinkWrap:
                          true, // Penting untuk GridView di dalam SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // Agar scroll ditangani oleh SingleChildScrollView utama
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 produk per baris
                        crossAxisSpacing: 12.0, // Jarak horizontal antar produk
                        mainAxisSpacing: 12.0, // Jarak vertikal antar produk
                        childAspectRatio:
                            0.7, // Rasio lebar terhadap tinggi produk (sesuaikan)
                      ),
                      itemCount:
                          displayedProducts.length, // Gunakan displayedProducts
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Product tapped: ${product['name']}");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryBlue, // Background kartu produk
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: kDarkBlue.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .stretch, // Agar gambar dan tombol memenuhi lebar
          children: [
            // Gambar Produk
            Expanded(
              flex: 5, // Gambar mengambil porsi lebih besar
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image.network(
                  product['imageUrl']!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: kLightBlue.withOpacity(0.3),
                      child: Center(
                        child: Icon(
                          Icons.inventory_2_outlined,
                          color: kVeryLightBlue.withOpacity(0.7),
                          size: 40,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          kVeryLightBlue,
                        ),
                        strokeWidth: 2.0,
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Detail Produk (Nama, Tombol Beli)
            Expanded(
              flex: 3, // Detail mengambil porsi lebih kecil
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name']!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kVeryLightBlue,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        print(
                          "Add to cart: ${product['name']} - \$${product['price']}",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kVeryLightBlue,
                        foregroundColor: kPrimaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ), // Sedikit tambah padding vertikal tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        minimumSize: const Size(
                          double.infinity,
                          30,
                        ), // Sesuaikan tinggi minimum
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Add to cart - \$${product['price'].toStringAsFixed(2)}",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleSection extends StatefulWidget {
  final List<Map<String, dynamic>> allArticles;

  const ArticleSection({super.key, required this.allArticles});

  @override
  State<ArticleSection> createState() => _ArticleSectionState();
}

class _ArticleSectionState extends State<ArticleSection> {
  List<Map<String, dynamic>> _displayedArticles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadRandomArticles();
  }

  void _loadRandomArticles() {
    if (widget.allArticles.isNotEmpty) {
      final List<Map<String, dynamic>> shuffled = List.from(widget.allArticles)
        ..shuffle(_random);
      setState(() {
        _displayedArticles = shuffled.take(6).toList();
      });
    } else {
      setState(() {
        _displayedArticles = [];
      }); // Handle jika data kosong
    }
  }

  @override
  void didUpdateWidget(covariant ArticleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.allArticles != widget.allArticles) {
      _loadRandomArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Article",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkBlue,
              ),
            ),
          ),
          const SizedBox(height: 5),

          // Daftar Artikel (GridView)
          _displayedArticles.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "No articles to display.",
                    style: TextStyle(color: kDarkBlue.withOpacity(0.7)),
                  ),
                ),
              )
              : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 artikel per baris, bisa disesuaikan
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio:
                      0.65, // Sesuaikan agar konten pas (tinggi/lebar)
                ),
                itemCount: _displayedArticles.length,
                itemBuilder: (context, index) {
                  final article = _displayedArticles[index];
                  return ArticleCard(article: article);
                },
              ),
        ],
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Article tapped: ${article['title']}");
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(article: article)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background kartu artikel
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: kLightBlue.withOpacity(0.6),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Artikel
            Expanded(
              flex: 3, // Gambar mengambil porsi
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image.network(
                  article['imageUrl']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: kLightBlue.withOpacity(0.2),
                      child: Center(
                        child: Icon(
                          Icons.article_outlined,
                          color: kDarkBlue.withOpacity(0.4),
                          size: 40,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryBlue),
                        strokeWidth: 2.0,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Detail Artikel
            Expanded(
              flex: 4, // Detail mengambil porsi lebih besar agar teks muat
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Untuk menata konten
                  children: [
                    Column(
                      // Kolom untuk judul dan summary
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title']!,
                          style: TextStyle(
                            fontSize: 13, // Ukuran font judul
                            fontWeight: FontWeight.bold,
                            color: kDarkBlue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          article['summary']!,
                          style: TextStyle(
                            fontSize: 11, // Ukuran font summary
                            color: kDarkBlue.withOpacity(0.7),
                          ),
                          maxLines: 3, // Batasi jumlah baris summary
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Tanggal Artikel
                    Align(
                      // Rata kanan untuk tanggal
                      alignment: Alignment.centerRight,
                      child: Text(
                        article['date']!,
                        style: TextStyle(
                          fontSize: 10,
                          color: kDarkBlue.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
