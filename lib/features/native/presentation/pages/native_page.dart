import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // SINKRONISASI: Nama channel harus sama persis dengan di MainActivity.kt
  static const platform = MethodChannel('utd.ac.id/native_jembatan');

  String _batteryDisplay = '--';
  int _batteryRawValue = 0;

  // 1. Fungsi mengambil data baterai dari Kotlin
  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryRawValue = result;
        _batteryDisplay = '$result%';
      });
    } on PlatformException catch (e) {
      setState(() {
        _batteryDisplay = "Err";
      });
      debugPrint("Gagal mengambil baterai: '${e.message}'.");
    }
  }

  // 2. Fungsi memunculkan Toast melalui Kotlin
  Future<void> _showNativeToast() async {
    try {
      await platform.invokeMethod('showToast', {
        "message": "Halo Jaisy (20123066)! Native Toast Berhasil."
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil Toast: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF101820); // Deep Navy
    const Color accentColor = Color(0xFF8CFF00);  // Lime Green

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'NATIVE HARDWARE',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Bagian Visual Baterai Kustom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    "BATTERY STATUS",
                    style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(height: 30),
                  // Visual Baterai Kustom
                  _buildBatteryIcon(accentColor),
                  const SizedBox(height: 20),
                  Text(
                    _batteryDisplay,
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "CURRENT CAPACITY",
                    style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Grid Menu Native
            _buildNativeActionCard(
              title: "REFRESH SYSTEM",
              subtitle: "Ambil data kapasitas baterai terbaru",
              icon: Icons.refresh_rounded,
              color: primaryColor,
              onTap: _getBatteryLevel,
            ),
            
            const SizedBox(height: 16),
            
            _buildNativeActionCard(
              title: "TRIGGER TOAST",
              subtitle: "Panggil fungsi Toast Android OS",
              icon: Icons.notifications_active_outlined,
              color: accentColor,
              textColor: primaryColor,
              onTap: _showNativeToast,
            ),
            
            const SizedBox(height: 40),
            const Text(
              "COMMUNICATING VIA METHOD CHANNEL",
              style: TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menggambar Baterai Kustom
  Widget _buildBatteryIcon(Color color) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // Indikator Isi Baterai
          FractionallySizedBox(
            widthFactor: _batteryRawValue / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Ikon Petir (Hanya muncul jika ada daya)
          Center(
            child: Icon(
              Icons.bolt_rounded,
              color: _batteryRawValue > 50 ? Colors.black : Colors.white,
              size: 30,
            ),
          )
        ],
      ),
    );
  }

  // Widget untuk Kartu Aksi
  Widget _buildNativeActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: .2), blurRadius: 10, offset: const Offset(0, 5))
          ]
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 32),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: textColor.withValues(alpha: .6), fontSize: 11),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: .4)),
          ],
        ),
      ),
    );
  }
}