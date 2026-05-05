import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';

class DetailPage extends StatelessWidget {
  // SINKRONISASI: Parameter ini harus cocok dengan yang dikirim dari AppRouter
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Memanggil ProductService dari locator (GetIt)
    final productService = locator<ProductService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk Jaisy"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Product?>(
        // Mengambil detail produk berdasarkan ID
        future: productService.fetchProductDetail(productId),
        builder: (context, snapshot) {
          // 1. Kondisi Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Kondisi Error atau Data Kosong
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          // 3. Data Berhasil Dimuat
          final product = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Image.network(
                      product.image,
                      height: 280,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Nama Produk otomatis mengandung [Promo Ongkir] karena NIM Genap (6)
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "ID Produk: ${product.id}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Divider(height: 40),
                const Text(
                  "Deskripsi Produk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Detail spesifikasi produk ini dimuat secara real-time dari API publik.",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}