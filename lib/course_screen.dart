// File: lib/course_screen.dart

import 'package:flutter/material.dart';
import 'dart:math'; // Untuk memilih kata-kata acak

// Definisikan konstanta warna di sini atau impor dari file lain
const Color kDarkBlue = Color(0xFF000A26);
const Color kPrimaryBlue = Color(0xFF0F52BA);
const Color kLightBlue = Color(0xFFA6C6D8);
const Color kVeryLightBlue = Color(0xFFD6E5F2);

// Warna gradasi spesifik untuk header Course
const Color kCourseHeaderGradientStart = Color(0xFF0A224A);
const Color kCourseHeaderGradientEnd = Color(0xFF1D4A8E);

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  String _username = "Oumons";
  String _motivationalQuote = "";

  final List<String> _quotes = [
    "Find a Best Course For You",
    "Unlock Your Chess Potential",
    "Master the Game, One Move at a Time",
    "Elevate Your Strategy Skills",
    "Your Journey to Chess Mastery Starts Here",
  ];

  final Random _random = Random();

  // Data placeholder untuk statistik course
  final int _savedCourses = 8;
  final int _finishedCourses = 19;
  final int _inProgressCourses = 4;

  @override
  void initState() {
    super.initState();
    _changeQuote();
  }

  void _changeQuote() {
    setState(() {
      _motivationalQuote = _quotes[_random.nextInt(_quotes.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kVeryLightBlue, // Warna background utama halaman
      body: SingleChildScrollView(
        // Bungkus Column utama dengan SingleChildScrollView
        child: Column(
          children: [
            _buildCourseHeader(context),
            _buildCourseStatsSection(
              context,
            ), // Section statistik ditambahkan di sini
            const RecommendationSection(), // Konten lain dari halaman course akan ditambahkan di bawah ini
            const CourseFilterAndListSection(),
            Padding(
              // Tambahkan Padding agar konten berikutnya tidak terlalu mepet
              padding: const EdgeInsets.all(16.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // Layer 1: Gradient Background dengan Konten di dalamnya
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: topPadding + 20,
            bottom: 40, // Beri ruang yang cukup untuk teks dan avatar
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kCourseHeaderGradientStart, kCourseHeaderGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hi, $_username',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: kVeryLightBlue,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: kVeryLightBlue.withOpacity(0.2),
                    backgroundImage: const AssetImage(
                      "assets/images/img_avatar.png",
                    ), // PASTIKAN PATH INI BENAR
                    onBackgroundImageError: (exception, stackTrace) {
                      print(
                        'Error loading avatar image for header: $exception',
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _motivationalQuote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kVeryLightBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Layer 2: Gambar Bintik-bintik
        Positioned.fill(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
            child: Opacity(
              opacity: 1, // Opacity yang diubah agar lebih subtle
              child: Image.asset(
                "assets/images/dots_background.png", // PASTIKAN PATH INI BENAR dan aset valid
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print("Error loading dots_background.png: $error");
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // WIDGET BARU UNTUK SECTION STATISTIK COURSE
  Widget _buildCourseStatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem(
            context,
            iconPath:
                "assets/icons/ic_save_course.png", // GANTI DENGAN PATH ASET ANDA
            count: _savedCourses,
            label: "Save",
          ),
          _buildStatItem(
            context,
            iconPath:
                "assets/icons/ic_finished_course.png", // GANTI DENGAN PATH ASET ANDA
            count: _finishedCourses,
            label: "Finished",
          ),
          _buildStatItem(
            context,
            iconPath:
                "assets/icons/ic_inprogress_course.png", // GANTI DENGAN PATH ASET ANDA
            count: _inProgressCourses,
            label: "In Progress",
          ),
        ],
      ),
    );
  }

  // Helper widget untuk setiap item statistik
  Widget _buildStatItem(
    BuildContext context, {
    required String iconPath,
    required int count,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          radius: 30,
          backgroundColor: kLightBlue.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              iconPath,
              // color: kPrimaryBlue, // Uncomment jika ikon perlu diwarnai
              errorBuilder: (context, error, stackTrace) {
                print("Error loading stat icon $label: $error");
                return Icon(
                  Icons.bookmark_border,
                  color: kPrimaryBlue,
                  size: 28,
                ); // Fallback icon
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kDarkBlue,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: kDarkBlue.withOpacity(0.7),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({super.key});

  @override
  State<RecommendationSection> createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  // Data rekomendasi placeholder - nantinya ini dari API atau logika rekomendasi
  // Kita bisa gunakan data yang mirip dengan event atau course
  final List<Map<String, String>> _recommendationList = [
    {
      // GANTI DENGAN URL GAMBAR HIKARU YANG VALID
      "imageUrl":
          "https://images.chesscomfiles.com/uploads/v1/master_player/2977088e-fa8f-11e8-8015-45809e972e89.15c6cec0.250x250o.a30076060f1c.jpeg",
      "title": "Studi With Hikaru",
      "subtitle": "Only \$4",
      "buttonText": "Get Now",
    },
    {
      // GANTI DENGAN URL GAMBAR MAGNUS YANG VALID
      "imageUrl":
          "https://images.chesscomfiles.com/uploads/v1/master_player/2cfc1a6e-fa91-11e8-ac01-612003459e84.26451769.250x250o.f547f83363d0.jpeg",
      "title": "Advanced Tactics with Magnus",
      "subtitle": "Boost Your Rating!",
      "buttonText": "Learn More",
    },
    {
      // GANTI DENGAN URL GAMBAR LEVY YANG VALID
      "imageUrl":
          "https://images.chesscomfiles.com/uploads/v1/user/30479874.2a7c9449.200x200o.b850d6093554.jpeg",
      "title": "Endgame Essentials by Levy",
      "subtitle": "Win More Games",
      "buttonText": "View Course",
    },
  ];

  late Map<String, String> _currentRecommendation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _changeRecommendation();
  }

  void _changeRecommendation() {
    setState(() {
      _currentRecommendation =
          _recommendationList[_random.nextInt(_recommendationList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        24.0,
        16.0,
        16.0,
      ), // Padding untuk section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul "Recommendation"
          Text(
            "Recommendation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkBlue,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),

          // Kartu Rekomendasi (Mirip dengan Kartu Event)
          GestureDetector(
            onTap: () {
              print(
                "Recommendation card tapped: ${_currentRecommendation['title']}",
              );
              // Aksi ketika kartu rekomendasi diklik
            },
            child: Container(
              height: 150, // Sesuaikan tinggi kartu
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: kPrimaryBlue, // Warna background kartu
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
                  // Gambar Rekomendasi
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        _currentRecommendation['imageUrl']!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: kLightBlue.withOpacity(0.5),
                            child: Center(
                              child: Icon(
                                Icons.school_outlined,
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
                              strokeWidth: 2.0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Teks dan Tombol Rekomendasi
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentRecommendation['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kVeryLightBlue,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _currentRecommendation['subtitle']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: kVeryLightBlue.withOpacity(0.9),
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            print(
                              "Button '${_currentRecommendation['buttonText']}' pressed for recommendation: ${_currentRecommendation['title']}",
                            );
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
                              fontFamily: 'Poppins',
                            ),
                          ),
                          child: Text(_currentRecommendation['buttonText']!),
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

class CourseFilterAndListSection extends StatefulWidget {
  const CourseFilterAndListSection({super.key});

  @override
  State<CourseFilterAndListSection> createState() =>
      _CourseFilterAndListSectionState();
}

class _CourseFilterAndListSectionState
    extends State<CourseFilterAndListSection> {
  // Data course placeholder (sama seperti di CoursesSection sebelumnya)
  // Nantinya ini akan diambil dari state yang lebih tinggi atau API
  final List<Map<String, dynamic>> _allCourses = [
    {
      "id": "c1",
      "imageUrl": "...",
      "title": "Mastering Chess Fundamentals",
      "price": 100000,
      "rating": 4.5,
      "reviewCount": 50,
      "category": "beginner",
      "type": "paid",
    },
    {
      "id": "c2",
      "imageUrl": "...",
      "title": "Tactical Patterns & Strategy",
      "price": 0,
      "rating": 4.8,
      "reviewCount": 75,
      "category": "intermediate",
      "type": "free",
    },
    {
      "id": "c3",
      "imageUrl": "...",
      "title": "Opening Repertoire for All Levels",
      "price": 400000,
      "rating": 4.2,
      "reviewCount": 30,
      "category": "beginner",
      "type": "paid",
    },
    {
      "id": "c4",
      "imageUrl": "...",
      "title": "Free Basic Chess Rules",
      "price": 0,
      "rating": 4.0,
      "reviewCount": 120,
      "category": "beginner",
      "type": "free",
    },
    {
      "id": "c5",
      "imageUrl": "...",
      "title": "Advanced Endgame Techniques",
      "price": 350000,
      "rating": 4.9,
      "reviewCount": 90,
      "category": "expert",
      "type": "paid",
    },
    {
      "id": "c6",
      "imageUrl": "...",
      "title": "Popular Openings Analysis",
      "price": 150000,
      "rating": 4.7,
      "reviewCount": 60,
      "category": "intermediate",
      "type": "paid",
      "isPopular": true,
    },
  ];

  // State untuk filter
  String _selectedTypeFilter =
      "All Course"; // Untuk dropdown: All Course, Popular, Paid, Free
  String _selectedLevelFilter =
      "Beginner"; // Untuk tombol: Beginner, Intermediate, Expert

  List<Map<String, dynamic>> _filteredCourses = [];

  // GlobalKey untuk mendapatkan posisi dan ukuran tombol filter utama (untuk dropdown)
  final GlobalKey _filterButtonKey = GlobalKey();
  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry; // Untuk menampilkan dropdown

  @override
  void initState() {
    super.initState();
    // Tambahkan kategori dan tipe ke data course untuk filtering
    // Contoh: _allCourses[0]['category'] = 'beginner'; _allCourses[0]['type'] = 'paid';
    // Saya sudah tambahkan di data di atas.
    _applyFilters();
  }

  @override
  void dispose() {
    _removeDropdownOverlay(); // Pastikan overlay dihapus
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      List<Map<String, dynamic>> tempCourses = List.from(_allCourses);

      // Filter berdasarkan Tipe (Popular, Paid, Free)
      if (_selectedTypeFilter == "Popular") {
        tempCourses =
            tempCourses.where((course) => course['isPopular'] == true).toList();
      } else if (_selectedTypeFilter == "Paid") {
        tempCourses =
            tempCourses.where((course) => course['price'] > 0).toList();
      } else if (_selectedTypeFilter == "Free") {
        tempCourses =
            tempCourses.where((course) => course['price'] == 0).toList();
      }
      // Jika "All Course", tidak ada filter tipe yang diterapkan (semua course dari _allCourses)

      // Filter berdasarkan Level (Beginner, Intermediate, Expert)
      // Asumsi _selectedLevelFilter tidak pernah kosong, selalu ada satu yang terpilih.
      tempCourses =
          tempCourses
              .where(
                (course) =>
                    course['category']?.toString().toLowerCase() ==
                    _selectedLevelFilter.toLowerCase(),
              )
              .toList();

      _filteredCourses = tempCourses;
    });
  }

  // --- Logika untuk Dropdown Kustom (Akan kita implementasikan lebih detail) ---
  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdownOverlay();
    } else {
      _showDropdownOverlay();
    }
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _removeDropdownOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdownOverlay() {
    final RenderBox renderBox =
        _filterButtonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 5, // 5 adalah jarak dari tombol
            width: size.width, // Lebar dropdown sama dengan tombol
            child: Material(
              // Material agar bisa ada shadow dan warna
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kLightBlue),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      <String>['All Course', 'Popular', 'Paid', 'Free']
                          .map(
                            (String value) => ListTile(
                              title: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      _selectedTypeFilter == value
                                          ? kPrimaryBlue
                                          : kDarkBlue,
                                ),
                              ),
                              dense: true,
                              onTap: () {
                                setState(() {
                                  _selectedTypeFilter = value;
                                  _applyFilters();
                                });
                                _toggleDropdown(); // Tutup dropdown setelah memilih
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }
  // --- Akhir Logika Dropdown ---

  Widget _buildLevelFilterButton(String title) {
    bool isActive = _selectedLevelFilter == title;
    return Expanded(
      // Agar tombol mengambil ruang yang sama
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedLevelFilter = title;
              _applyFilters();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? kPrimaryBlue : kVeryLightBlue,
            foregroundColor: isActive ? kVeryLightBlue : kPrimaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isActive ? kPrimaryBlue : kLightBlue.withOpacity(0.5),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            elevation: isActive ? 3 : 1,
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Poppins',
            ),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // GANTI URL GAMBAR DI _allCourses DENGAN YANG VALID
    // Contoh (hanya untuk memastikan tidak error karena URL kosong):
    for (var course in _allCourses) {
      if (course['imageUrl'] == "...") {
        course['imageUrl'] =
            "https://via.placeholder.com/300x200.png?text=Course+Image";
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 24.0), // Padding atas section
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Tombol Filter Utama dan Filter Level
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Tombol Filter Utama (Dropdown Trigger)
                    Expanded(
                      // Beri ruang untuk tombol filter utama
                      flex: 2, // Sesuaikan rasio jika perlu
                      child: InkWell(
                        // Gunakan InkWell agar bisa ada Key
                        key: _filterButtonKey,
                        onTap: _toggleDropdown,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: kLightBlue.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kLightBlue),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.filter_list,
                                color: kDarkBlue.withOpacity(0.7),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _selectedTypeFilter,
                                  style: TextStyle(
                                    color: kDarkBlue,
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                _isDropdownOpen
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: kDarkBlue.withOpacity(0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Anda bisa menambahkan Spacer atau Expanded kosong jika ingin jarak
                    // const Spacer(flex: 1), // Contoh jika ingin ada jarak
                  ],
                ),
                const SizedBox(height: 12),
                // Tombol Filter Level
                Row(
                  children: [
                    _buildLevelFilterButton("Beginner"),
                    _buildLevelFilterButton("Intermediate"),
                    _buildLevelFilterButton("Expert"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daftar Course (Horizontal Scroll, sama seperti di CoursesSection sebelumnya)
          // Kita akan menggunakan ListView horizontal untuk daftar course di sini
          SizedBox(
            height: 260, // Sesuaikan tinggi area daftar course
            child:
                _filteredCourses.isEmpty
                    ? Center(
                      child: Text(
                        "No courses found for '$_selectedTypeFilter' & '$_selectedLevelFilter'",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kDarkBlue.withOpacity(0.7),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];
                        // Anda bisa menggunakan CourseCard yang sama dari section sebelumnya
                        // atau buat versi baru jika tampilannya berbeda.
                        // Untuk sekarang, kita asumsikan menggunakan CourseCard yang sudah ada.
                        // Jika CourseCard ada di file lain, pastikan diimpor.
                        // Jika CourseCard ada di file yang sama (home_screen.dart), pastikan bisa diakses.
                        return CourseCard(
                          course: course,
                        ); // Asumsi CourseCard sudah ada
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
    // ... (Implementasi UI CourseCard Anda seperti sebelumnya)
    // Pastikan URL gambar diisi, contoh:
    // course['imageUrl'] = course['imageUrl'] == "..." ? "https://via.placeholder.com/300x200.png?text=Course" : course['imageUrl'];

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Image.network(
              course['imageUrl']!,
              height: 120,
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
            ),
          ),
          Expanded(
            child: Padding(
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
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    course['price'] == 0 ? "Free" : "Rp. ${course['price']}",
                    style: TextStyle(
                      fontSize: 12,
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${course['rating']} (${course['reviewCount']})",
                        style: TextStyle(
                          fontSize: 12,
                          color: kDarkBlue.withOpacity(0.7),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
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
