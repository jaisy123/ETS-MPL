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
    // LOGIKA NIM: Delay 6 detik sesuai digit terakhir NIM 20123066
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Konsistensi palet warna Jaisy Exclusive
    const Color primaryColor = Color(0xFF101820); // Deep Navy
    const Color accentColor = Color(0xFF8CFF00);  // Lime Green

    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          // Dekorasi Background (Lingkaran halus agar tidak kaku)
          Positioned(
            top: -100,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: accentColor.withValues(alpha: 0.05),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO BARU: Menggunakan Container dengan Border Gaya Cyber
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: accentColor, width: 4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded, // Ikon petir untuk kesan energi/cepat
                    size: 80,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 30),
                // JUDUL DENGAN TIPOGRAFI PREMIUM
                const Text(
                  'JAISY',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
                const Text(
                  'EXCLUSIVE STORE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 60),
                // LOADING INDICATOR
                const SizedBox(
                  width: 40,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white10,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 20),
                // IDENTITAS NIM
                const Text(
                  'NIM: 20123066',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // FOOTER TEKS
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'EST. 2026',
                style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}