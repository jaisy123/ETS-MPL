import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Wajib untuk komunikasi native

class NativePage extends StatefulWidget {
  const NativePage({super.key});

  @override
  State<NativePage> createState() => _NativePageState();
}

class _NativePageState extends State<NativePage> {
  // SINKRONISASI: Nama channel harus sama persis dengan di MainActivity.kt
  static const platform = MethodChannel('utd.ac.id/native_jembatan');

  String _batteryLevel = 'Klik tombol untuk cek baterai';

  // 1. Fungsi mengambil data baterai dari Kotlin
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      // Memanggil method 'getBatteryLevel' di Kotlin
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Level Baterai Jaisy: $result%';
    } on PlatformException catch (e) {
      batteryLevel = "Gagal mengambil baterai: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  // 2. Fungsi memunculkan Toast melalui Kotlin
  Future<void> _showNativeToast() async {
    try {
      // SINKRONISASI: Key 'message' harus sama dengan call.argument di Kotlin
      await platform.invokeMethod('showToast', {
        "message": "Halo Jaisy (20123066)! Native Toast Berhasil."
      });
    } on PlatformException catch (e) {
      debugPrint("Gagal memanggil Toast: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native Feature Jaisy'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilan Status Baterai
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.battery_charging_full, size: 50, color: Colors.green),
                    const SizedBox(height: 10),
                    Text(
                      _batteryLevel,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Tombol Cek Baterai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _getBatteryLevel,
                icon: const Icon(Icons.refresh),
                label: const Text('CEK BATERAI SEKARANG'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Tombol Munculkan Toast
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showNativeToast,
                icon: const Icon(Icons.message),
                label: const Text('TAMPILKAN NATIVE TOAST'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}