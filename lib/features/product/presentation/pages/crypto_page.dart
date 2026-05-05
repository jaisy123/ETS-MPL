import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Untuk compute

// 1. FUNGSI BERAT DI LUAR CLASS (Wajib untuk Isolate)[cite: 7]
int tugasMenghitungBerat(int jumlahLooping) {
  int hasil = 0;
  for (int i = 0; i < jumlahLooping; i++) {
    hasil += i;
  }
  return hasil;
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  late WebSocketChannel _channel;
  String _currentPrice = '0.00';

  @override
  void initState() {
    super.initState();
    // MENGGUNAKAN API BINANCE (Temanmu)[cite: 7]
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Cegah kebocoran memori[cite: 7]
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Background halus
      appBar: AppBar(
        title: const Text('Jaisy Crypto Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Header Info Personal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                const Text('Monitoring BTC Real-time', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 5),
                // LOGIKA PERSONAL: Nama & NIM Kamu
                const Text(
                  'Jaisy - 20123066',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Kartu Harga Premium
                  _buildPriceCard(),

                  const SizedBox(height: 30),

                  // Indikator UI Lancar (WAJIB ETS: Tidak boleh macet saat Isolate jalan)
                  const Text('UI Responsiveness Check:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 15),
                  const CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),

                  const SizedBox(height: 40),

                  // Tombol Kalkulasi dengan Style Konsisten
                  _buildCalculateButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: .1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.currency_bitcoin_rounded, size: 80, color: Colors.orange),
          const SizedBox(height: 15),
          const Text('BTC / USDT', style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('Koneksi Terputus!', style: TextStyle(color: Colors.red));
              if (!snapshot.hasData) return const CircularProgressIndicator();

              final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
              final String price = dataJson['p'] ?? '0.00'; // Format Binance memakai key 'p'[cite: 7]
              _currentPrice = double.parse(price).toStringAsFixed(2);

              return Text(
                '\$ $_currentPrice',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.teal),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
        ),
        onPressed: () async {
          debugPrint("Memulai Isolate Jaisy NIM 66...");
          
          // LOGIKA PERSONAL: 66 * 10.000.000 = 660.000.000[cite: 8]
          const int nimLoopFactor = 66 * 10000000;

          // Menjalankan Isolate agar UI tidak freeze[cite: 7]
          final result = await compute(tugasMenghitungBerat, nimLoopFactor);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Kalkulasi NIM 66 Selesai: $result'),
                backgroundColor: Colors.teal,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        icon: const Icon(Icons.calculate),
        label: const Text('KALKULASI PAJAK (ISOLATE NIM 66)', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}