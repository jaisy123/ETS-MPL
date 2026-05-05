import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi palet warna agar konsisten dengan DetailPage
    const Color primaryColor = Color(0xFF101820); // Deep Navy
    const Color accentColor = Color(0xFF8CFF00);  // Lime Green

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'JAISY KATALOG',
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.5,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.white),
            onPressed: () => context.push('/todo'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_cell_outlined, color: Colors.white),
            onPressed: () => context.push('/native'),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. Tampilan saat Loading (Sesuai NIM 6 detik)
          if (state is ProductLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  SizedBox(height: 20),
                  Text(
                    'MENYIAPKAN KOLEKSI...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          // 2. Tampilan saat Sukses
          if (state is ProductLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.products.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.products[index];
                return GestureDetector(
                  onTap: () => context.push('/detail/${item.id}'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Thumbnail Produk
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: Colors.white,
                              child: Image.network(
                                item.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Info Produk
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: primaryColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ID: ${item.id}',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Badge Promo Mini
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: accentColor.withValues(alpha: .2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    "FREE ONGKIR",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: primaryColor),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          // 3. Tampilan saat Error
          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      // Floating Action Button ala Jaisy Exclusive
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        label: const Text(
          'LIVE CRYPTO',
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        icon: const Icon(Icons.analytics_outlined, color: primaryColor),
        backgroundColor: accentColor,
        elevation: 4,
      ),
    );
  }
}