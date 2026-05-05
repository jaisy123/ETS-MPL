import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/product/presentation/pages/splash_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/product/presentation/pages/detail_page.dart';
import '../../features/product/presentation/pages/crypto_page.dart';
import '../../features/native/presentation/pages/native_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../di/injection.dart';

class AppRouter {
  static final router = GoRouter(
    // LOGIKA NIM: Mulai dari Splash Screen (Delay 6 detik sesuai NIM 66)
    initialLocation: '/splash',

    routes: [
      // 1. Splash Screen
      GoRoute(
        path: '/splash', 
        builder: (context, state) => const SplashPage()
      ),

      // 2. Katalog Produk (Home)
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => locator<ProductCubit>()..fetchAllProducts(),
          child: const ProductPage(),
        ),
      ),

      // 3. Detail Produk
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(productId: id);
        },
      ),

      // 4. Monitoring Crypto (WebSocket & Isolate)
      GoRoute(
        path: '/crypto', 
        builder: (context, state) => const CryptoPage()
      ),

      // 5. Integrasi Native (Battery & Toast)
      GoRoute(
        path: '/native', 
        builder: (context, state) => const NativePage()
      ),

      // 6. Bookmark/Todo (Isar Database)
      GoRoute(
        path: '/todo', 
        builder: (context, state) => const TodoPage()
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Halaman tidak ditemukan!')),
    ),
  );
}