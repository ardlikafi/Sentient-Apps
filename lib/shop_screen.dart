import 'package:flutter/material.dart';

// --- Salinan Konstanta Warna dari home_screen.dart ---
const Color kDarkBlue = Color(0xFF000A26);
const Color kPrimaryBlue = Color(0xFF0F52BA); // Akan digunakan untuk tombol, kartu produk
const Color kLightBlue = Color(0xFFA6C6D8);
const Color kVeryLightBlue = Color(0xFFD6E5F2); // Untuk background body & teks AppBar

// --- Konstanta Warna Gradasi untuk AppBar ---
const Color HeaderGradientStart = Color(0xFF000A26);
const Color HeaderGradientEnd = Color(0xFF0A3D91);

// --- Salinan ProductCard dari home_screen.dart ---
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
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
                      child: Center(child: Icon(Icons.inventory_2_outlined, color: kVeryLightBlue.withOpacity(0.7), size: 40)),
                    );
                  },
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kVeryLightBlue),
                        strokeWidth: 2.0,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
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
                        print("Add to cart: ${product['name']} - \$${product['price']}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kVeryLightBlue,
                        foregroundColor: kPrimaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        minimumSize: const Size(double.infinity, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("Add to cart - \$${product['price'].toStringAsFixed(2)}"),
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


class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Map<String, dynamic>> _allProducts = [
    {
      "id": "p1",
      "imageUrl": "https://m.media-amazon.com/images/I/71zVVEVB5tL._AC_SL1500_.jpg",
      "name": "Beautiful Metal Chess Set",
      "price": 99.00,
      "category": "chess",
    },
    {
      "id": "p2",
      "imageUrl": "https://m.media-amazon.com/images/I/81M7o+-V3CL._AC_SL1500_.jpg",
      "name": "Beautiful Handcrafted Wooden Chess Set",
      "price": 99.00,
      "category": "chess",
    },
    {
      "id": "p3",
      "imageUrl": "https://m.media-amazon.com/images/I/71v5Xyol6qL._AC_SL1500_.jpg",
      "name": "Elegant Glass Chess Set",
      "price": 99.00,
      "category": "chess",
    },
    {
      "id": "p4",
      "imageUrl": "https://m.media-amazon.com/images/I/71UohSAT3DL._AC_SL1500_.jpg",
      "name": "Luxurious Marble Chess Set",
      "price": 99.00,
      "category": "chess",
    },
    {
      "id": "p5",
      "imageUrl": "https://m.media-amazon.com/images/I/61O23yq4mDL._AC_SL1000_.jpg",
      "name": "Chess Clock Digital Timer",
      "price": 25.00,
      "category": "items",
    },
    {
      "id": "p6",
      "imageUrl": "https://m.media-amazon.com/images/I/71g7g9WnB2L._AC_SL1500_.jpg",
      "name": "Roll-Up Chess Board",
      "price": 15.00,
      "category": "items",
    },
    {
      "id": "p7",
      "imageUrl": "https://m.media-amazon.com/images/I/61805m7zBwL._AC_UF894,1000_QL80_.jpg",
      "name": "Professional Chess Scorebook",
      "price": 12.50,
      "category": "items",
    },
    {
      "id": "p8",
      "imageUrl": "https://www.chesshouse.com/cdn/shop/products/Wegiel-Polish-International-Tournament-Chess-Set-Pieces-Box-Board-Extra-Queens_1_c07d68b7-175e-48a2-8908-77b4c4a5e1be.jpg?v=1627408194",
      "name": "Tournament Standard Chess Pieces",
      "price": 45.00,
      "category": "chess",
    }
  ];

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
        _filteredProducts = List.from(_allProducts);
      } else if (_selectedFilter == "Chess") {
        _filteredProducts = _allProducts.where((product) => product['category'] == 'chess').toList();
      } else if (_selectedFilter == "Items") {
        _filteredProducts = _allProducts.where((product) => product['category'] == 'items').toList();
      }
    });
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
              side: BorderSide(color: isActive ? kPrimaryBlue : kLightBlue, width: 1)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: isActive ? 2 : 0,
        ),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kVeryLightBlue,
      appBar: AppBar(
        // backgroundColor: kPrimaryBlue, // Dihapus atau di-set transparent
        backgroundColor: Colors.transparent, // Penting agar gradasi terlihat
        elevation: 1.0,
        centerTitle: true,
        flexibleSpace: Container( // Widget untuk gradasi
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [HeaderGradientStart, HeaderGradientEnd],
              begin: Alignment.topCenter, // Mulai gradasi dari kiri tengah
              end: Alignment.bottomCenter,   // Akhiri gradasi di kanan tengah
              // Anda bisa juga menggunakan:
              // begin: Alignment.topLeft,
              // end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Shop",
              style: TextStyle(
                color: kVeryLightBlue, // Pastikan warna teks kontras dengan gradasi
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "Find Your Perfect Chess Gear",
              style: TextStyle(
                color: kVeryLightBlue, // Pastikan warna teks kontras dengan gradasi
                fontSize: 13,
              ),
            ),
          ],
        ),
        // Jika ada tombol kembali (leading icon), warnanya mungkin perlu disesuaikan
        // iconTheme: IconThemeData(color: kVeryLightBlue), // Contoh jika tombol kembali otomatis ada
        leading: Navigator.canPop(context) ? IconButton(
          icon: const Icon(Icons.arrow_back, color: kVeryLightBlue), // Sesuaikan warna ikon kembali
          onPressed: () => Navigator.of(context).pop(),
        ) : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Row(
                  children: [
                    _buildFilterButton("All Product"),
                    _buildFilterButton("Chess"),
                    _buildFilterButton("Items"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _filteredProducts.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Text(
                    "No products found for '$_selectedFilter'",
                    style: TextStyle(color: kDarkBlue.withOpacity(0.7), fontSize: 16),
                  ),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}