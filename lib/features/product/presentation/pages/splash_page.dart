import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // LOGIKA NIM: Delay 6 detik sesuai digit terakhir NIM 20123066[cite: 8]
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            const Text('UTD Store Jaisy', style: TextStyle(fontSize: 24, color: Colors.white)),
            const Text('NIM: 20123066', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}