import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

// 1. FUNGSI BERAT DI LUAR CLASS (Isolate)
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
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    // MENGGUNAKAN API BINANCE
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://data-stream.binance.vision/ws/btcusdt@trade'),
    );
  }

  @override
  void dispose() {
    _channel.sink.close(); // Cegah kebocoran memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF101820); // Deep Navy
    const Color accentColor = Color(0xFF8CFF00);  // Lime Green

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'JAISY CRYPTO HUB',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryColor, primaryColor.withValues(alpha: 0.8)],
          ),
        ),
        child: Column(
          children: [
            // Header Info Personal (Glassmorphism look)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LIVE MONITORING', style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      Text('BTC / USDT TRADE', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('OPERATOR', style: TextStyle(color: Colors.white38, fontSize: 10)),
                      Text('JAISY - 66', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Kartu Harga Real-time
                    _buildModernPriceCard(accentColor),

                    const SizedBox(height: 40),

                    // Indikator Responsivitas UI
                    const Text('SYSTEM STABILITY CHECK', style: TextStyle(color: Colors.white38, fontSize: 10, letterSpacing: 2)),
                    const SizedBox(height: 15),
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_isCalculating ? Colors.redAccent : accentColor),
                    ),

                    const SizedBox(height: 50),

                    // Tombol Kalkulasi Isolate
                    _buildNeonButton(primaryColor, accentColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernPriceCard(Color accent) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.05), blurRadius: 40, spreadRadius: -10),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.auto_graph_rounded, size: 50, color: accent),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: _channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('LINK ERROR', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold));
              if (!snapshot.hasData) return const CircularProgressIndicator(color: Colors.white24);

              final Map<String, dynamic> dataJson = jsonDecode(snapshot.data.toString());
              final String price = dataJson['p'] ?? '0.00';
              _currentPrice = double.parse(price).toStringAsFixed(2);

              return Column(
                children: [
                  Text(
                    '\$ $_currentPrice',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1),
                  ),
                  const SizedBox(height: 5),
                  Text('REAL-TIME MARKET DATA', style: TextStyle(color: accent.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeonButton(Color primary, Color accent) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 65,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isCalculating ? Colors.transparent : accent,
              foregroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: accent, width: 2),
              ),
              elevation: _isCalculating ? 0 : 10,
              shadowColor: accent.withValues(alpha: 0.5),
            ),
            onPressed: _isCalculating ? null : () async {
              setState(() => _isCalculating = true);
              debugPrint("Memulai Isolate Jaisy NIM 66...");
              
              const int nimLoopFactor = 66 * 10000000;
              final result = await compute(tugasMenghitungBerat, nimLoopFactor);

              setState(() => _isCalculating = false);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('COMPUTATION SUCCESS: $result', style: const TextStyle(fontWeight: FontWeight.bold)),
                    backgroundColor: accent,
                    margin: const EdgeInsets.all(20),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: _isCalculating 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('EXECUTE HEAVY CALCULATION (NIM 66)', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ),
        const SizedBox(height: 12),
        const Text('ISOLATE WILL PREVENT UI FREEZING', style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1)),
      ],
    );
  }
}