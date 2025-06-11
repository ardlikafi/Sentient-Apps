// File: lib/course_screen.dart

import 'package:flutter/material.dart';
import 'dart:math'; // Untuk memilih kata-kata acak
import 'dart:async';
import 'package:intl/intl.dart';

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
                "assets/images/bg_titik.png", // PASTIKAN PATH INI BENAR dan aset valid
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
  // Logika disalin dari EventSection
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, String>> _recommendationList = [
    {"imageUrl": "https://images.chesscomfiles.com/uploads/v1/master_player/2977088e-fa8f-11e8-8015-45809e972e89.15c6cec0.250x250o.a30076060f1c.jpeg", "title": "Studi With Hikaru", "subtitle": "Only \$4", "buttonText": "Get Now"},
    {"imageUrl": "https://images.chesscomfiles.com/uploads/v1/master_player/2cfc1a6e-fa91-11e8-ac01-612003459e84.26451769.250x250o.f547f83363d0.jpeg", "title": "Masterclass with Magnus", "subtitle": "Limited Seats!", "buttonText": "Join Now"},
    {"imageUrl": "https://images.chesscomfiles.com/uploads/v1/user/30479874.2a7c9449.200x200o.b850d6093554.jpeg", "title": "GothamChess Bootcamp", "subtitle": "Become a Chess Bruh", "buttonText": "Buy"},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    if (_recommendationList.length > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;
      int nextPage = (_currentPage + 1) % _recommendationList.length;
      _pageController.animateToPage(nextPage, duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recommendation", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkBlue)),
          const SizedBox(height: 12),
          // Menggunakan PageView untuk carousel
          SizedBox(
            height: 140, // Tinggi banner
            child: PageView.builder(
              controller: _pageController,
              itemCount: _recommendationList.length,
              onPageChanged: (int page) => setState(() => _currentPage = page),
              itemBuilder: (context, index) {
                final recommendation = _recommendationList[index];
                return _buildRecommendationCard(recommendation: recommendation);
              },
            ),
          ),
          const SizedBox(height: 12),
          // Indikator titik
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _recommendationList.length,
                  (index) => _buildDot(index: index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard({required Map<String, String> recommendation}) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(color: kPrimaryBlue, borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        children: [
          // ### PERUBAHAN 1: Kurangi flex gambar ###
          // Mengubah flex dari 5 menjadi 4 akan membuat gambar sedikit lebih kecil
          // dan memberikan lebih banyak ruang untuk teks.
          Expanded(
              flex: 4,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                      recommendation['imageUrl']!,
                      fit: BoxFit.cover,
                      height: double.infinity
                  )
              )
          ),
          const SizedBox(width: 16),

          // ### PERUBAHAN 2: Tambah flex untuk teks ###
          Expanded(
            flex: 5, // Diberi ruang lebih banyak
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        recommendation['title']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 2),
                    Text(
                        recommendation['subtitle']!,
                        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis
                    ),
                  ],
                ),

                // ### PERUBAHAN 3 (Opsional tapi direkomendasikan): Buat tombol lebih ringkas ###
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kVeryLightBlue,
                        foregroundColor: kPrimaryBlue,
                        // Tap target size diatur agar tidak menambah padding internal yang tidak perlu
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6), // Padding lebih kecil
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)
                    ),
                    child: Text(recommendation['buttonText']!)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required int index}) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(color: isActive ? kPrimaryBlue : kLightBlue, borderRadius: BorderRadius.circular(4)),
    );
  }
}

class CourseFilterAndListSection extends StatefulWidget {
  const CourseFilterAndListSection({super.key});

  @override
  State<CourseFilterAndListSection> createState() => _CourseFilterAndListSectionState();
}

class _CourseFilterAndListSectionState extends State<CourseFilterAndListSection> {
  final List<Map<String, dynamic>> _allCourses = [
    {"id": "c1", "imageUrl": "https://img.youtube.com/vi/c8bHj_Idp-Y/0.jpg", "title": "Mastering Chess Fundamentals", "price": 100000, "rating": 4.5, "reviewCount": 50, "category": "Beginner"},
    {"id": "c2", "imageUrl": "https://img.youtube.com/vi/yf6IIc2a3vA/0.jpg", "title": "Tactical Patterns & Strategy", "price": 0, "rating": 4.8, "reviewCount": 75, "category": "Intermediate", "isPopular": true},
    {"id": "c3", "imageUrl": "https://img.youtube.com/vi/S-6yu8_c18Y/0.jpg", "title": "Opening Repertoire for All Levels", "price": 400000, "rating": 4.2, "reviewCount": 30, "category": "Expert"},
  ];

  String _selectedTypeFilter = "All Course";
  String _selectedLevelFilter = "Beginner";
  List<Map<String, dynamic>> _filteredCourses = [];

  final GlobalKey _filterButtonKey = GlobalKey();
  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  @override
  void dispose() {
    _removeDropdownOverlay();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      List<Map<String, dynamic>> tempCourses = List.from(_allCourses);
      if (_selectedTypeFilter == "Popular") tempCourses = tempCourses.where((c) => c['isPopular'] == true).toList();
      else if (_selectedTypeFilter == "Paid") tempCourses = tempCourses.where((c) => c['price'] > 0).toList();
      else if (_selectedTypeFilter == "Free") tempCourses = tempCourses.where((c) => c['price'] == 0).toList();

      tempCourses = tempCourses.where((c) => c['category'] == _selectedLevelFilter).toList();
      _filteredCourses = tempCourses;
    });
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _removeDropdownOverlay();
    } else {
      _showDropdownOverlay();
    }
    setState(() => _isDropdownOpen = !_isDropdownOpen);
  }

  void _removeDropdownOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdownOverlay() {
    final RenderBox renderBox = _filterButtonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 5,
        width: 150,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: kLightBlue)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <String>['All Course', 'Popular', 'Paid', 'Free']
                  .map((value) => ListTile(
                title: Text(value, style: TextStyle(fontSize: 14, color: _selectedTypeFilter == value ? kPrimaryBlue : kDarkBlue)),
                dense: true,
                onTap: () {
                  setState(() {
                    _selectedTypeFilter = value;
                    _applyFilters();
                  });
                  _toggleDropdown();
                },
              ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  // Tombol untuk filter level (Beginner, Intermediate, Expert)
  Widget _buildLevelFilterButton(String title) {
    bool isActive = _selectedLevelFilter == title;
    return Expanded(
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
            elevation: isActive ? 2 : 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isActive ? BorderSide.none : const BorderSide(color: kPrimaryBlue, width: 1.5),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          child: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        children: [
          // Baris pertama untuk tombol filter
          Row(
            children: [
              // Tombol Dropdown "All Course"
              InkWell(
                key: _filterButtonKey,
                onTap: _toggleDropdown,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: kVeryLightBlue,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryBlue, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_list_rounded, color: kPrimaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _selectedTypeFilter, // <-- DIUBAH MENJADI VARIABEL STATE
                        style: const TextStyle(color: kPrimaryBlue, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Baris kedua untuk filter level
          Row(
            children: [
              _buildLevelFilterButton("Beginner"),
              _buildLevelFilterButton("Intermediate"),
              _buildLevelFilterButton("Expert"),
            ],
          ),
          const SizedBox(height: 20),

          // Daftar Course dalam GridView
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7, // Disesuaikan agar kartu lebih tinggi
            ),
            itemCount: _filteredCourses.length,
            itemBuilder: (context, index) {
              final course = _filteredCourses[index];
              return CourseCard(course: course);
            },
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
    // Pastikan 'price' di-cast sebagai num untuk keamanan
    final price = course['price'] as num? ?? 0;

    return GestureDetector(
      onTap: () {
        print("Course tapped: ${course['title']}");
      },
      child: Container(
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
            // Gambar Course
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
                      child: Icon(Icons.photo_size_select_actual_outlined, color: kDarkBlue.withOpacity(0.5), size: 30),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryBlue),
                        strokeWidth: 2.0,
                        value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Detail Course
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title']!,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kDarkBlue),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price == 0 ? "Free" : "Rp. ${NumberFormat.decimalPattern('id_ID').format(price)}",
                      style: TextStyle(fontSize: 12, color: kPrimaryBlue, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${course['rating']} (${course['reviewCount']})",
                          style: TextStyle(fontSize: 12, color: kDarkBlue.withOpacity(0.7)),
                        ),
                      ],
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