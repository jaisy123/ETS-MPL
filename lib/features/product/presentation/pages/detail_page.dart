import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import 'package:utd_store_jaisy/features/todo/data/isar_service.dart';
import '../../domain/product_service.dart';
import '../../domain/product_model.dart';

class DetailPage extends StatelessWidget {
  final String productId;

  const DetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final productService = locator<ProductService>();
    final isarService = locator<IsarService>();

    // Warna Pengganti Hitam (Deep Navy/Charcoal)
    const Color primaryColor = Color(0xFF101820); // Navy Gelap yang sangat elegan
    const Color accentColor = Color(0xFF8CFF00); // Hijau Lime yang cerah

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "JAISY EXCLUSIVE",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<Product?>(
        future: productService.fetchProductDetail(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat detail produk"));
          }

          final product = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Area Gambar dengan Badge Free Ongkir (NIM Genap)
                      Stack(
                        children: [
                          Container(
                            height: 350,
                            width: double.infinity,
                            color: const Color(0xFFF8F8F8),
                            child: Image.network(product.image, fit: BoxFit.contain),
                          ),
                          Positioned(
                            top: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.local_shipping, size: 16),
                                  SizedBox(width: 4),
                                  Text("FREE ONGKIR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${product.name} [PROMO ONGKIR]",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                            const SizedBox(height: 8),
                            const Text("Rp249.000", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                            const Divider(height: 32),
                            const Row(
                              children: [
                                Icon(Icons.description_outlined, size: 20),
                                SizedBox(width: 8),
                                Text("DESKRIPSI", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Produk eksklusif ini dikurasi secara real-time dari API publik. Material berkualitas tinggi dengan finishing detail yang presisi.",
                              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                            ),
                            const SizedBox(height: 20),
                            // Info Kualitas (Style Grid kecil)
                            _buildFeatureInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Action Bar (Tombol Tambah ke Bookmark)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Row(
                  children: [
                    _buildIconButton(Icons.chat_bubble_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            // LOGIKA: Simpan ke Isar dengan Timestamp
                            await isarService.saveBookmark(product.name, product.image);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Berhasil disimpan ke Bookmark Jaisy!'), backgroundColor: primaryColor),
                              );
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark_add),
                              SizedBox(width: 8),
                              Text("TAMBAH KE BOOKMARK", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Colors.black87),
    );
  }

  Widget _buildFeatureInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FeatureItem(Icons.verified_outlined, "Premium"),
          _FeatureItem(Icons.history, "7 Hari"),
          _FeatureItem(Icons.speed, "Cepat"),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}