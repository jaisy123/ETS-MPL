import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  // 1. WAJIB: Memastikan plugin Flutter terinisialisasi sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // 2. SANGAT PENTING: Inisialisasi Service Locator (GetIt)
  setupLocator();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // UPDATE: Menggunakan namamu Muhamad Taupik Anjana
      title: 'UTD Store Taupik',
      theme: AppTheme.lightTheme, 
      // Menggunakan konfigurasi router yang sudah diarahkan ke SplashPage
      routerConfig: AppRouter.router, 
    );
  }
}