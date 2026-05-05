import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog UTD Store Jaisy'),
        actions: [
          // Navigasi ke halaman Bookmark (Isar)
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => context.push('/todo'),
          ),
          // Navigasi ke halaman Native (Baterai & Toast)
          IconButton(
            icon: const Icon(Icons.settings_cell),
            onPressed: () => context.push('/native'),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          // 1. Tampilan saat Loading (Delay 6 detik sesuai NIM)
          if (state is ProductLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menunggu data sesuai NIM (6 detik)...'),
                ],
              ),
            );
          }

          // 2. Tampilan saat Sukses
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final item = state.products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      item.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image),
                    ),
                    // Nama sudah otomatis mengandung [Promo Ongkir] dari Repository
                    title: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('ID: ${item.id}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => context.push('/detail/${item.id}'),
                  ),
                );
              },
            );
          }

          // 3. Tampilan saat Error
          if (state is ProductError) {
            return Center(
              child: Text(state.message, style: const TextStyle(color: Colors.red)),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      // Tombol mengambang untuk ke halaman Crypto (WebSocket)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crypto'),
        label: const Text('Live Crypto'),
        icon: const Icon(Icons.currency_bitcoin),
        backgroundColor: Colors.orange,
      ),
    );
  }
}