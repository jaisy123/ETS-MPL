import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Pastikan path import ini sesuai dengan struktur folder di VS Code kamu
import '../../features/product/presentation/pages/splash_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/crypto_page.dart';
import '../../features/product/presentation/pages/native_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../di/injection.dart';

class AppRouter {
  static final router = GoRouter(
    // LOGIKA NIM: Aplikasi harus dimulai dari Splash Screen (Delay 6 detik)
    initialLocation: '/splash', 
    
    routes: [
      // Halaman Splash (Identitas Personal)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Halaman Utama (Katalog Produk)
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocProvider(
            // Meminta Cubit dari Get_it dan langsung mengambil data API
            create: (context) => locator<ProductCubit>()..fetchAllProducts(), 
            child: const ProductPage(),
          );
        },
      ),

      // Halaman Detail Produk
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return DetailPage(productId: productId);
        },
      ),

      // Fitur Real-time Crypto (WebSocket & Isolate NIM 66)
      GoRoute(
        path: '/crypto', 
        builder: (context, state) => const CryptoPage(),
      ),
      
      // Fitur Native (Baterai & Toast Kotlin)
      GoRoute(
        path: '/native', 
        builder: (context, state) => const NativePage(),
      ),

      // Fitur Bookmark/Todo (Isar Database Reaktif)
      GoRoute(
        path: '/todo', 
        builder: (context, state) => const TodoPage(),
      ),
    ],

    // Fallback jika user mengakses halaman yang tidak ada
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Halaman tidak ditemukan!')),
    ),
  );
}