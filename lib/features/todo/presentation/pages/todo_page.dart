import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../../../core/di/injection.dart';
import '../../data/isar_service.dart';
import 'package:utd_store_jaisy/features/todo/domain/todo_model.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = locator<IsarService>();
    
    // Konsistensi palet warna Jaisy Exclusive
    const Color primaryColor = Color(0xFF101820); // Deep Navy
    const Color accentColor = Color(0xFF8CFF00);  // Lime Green

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MY BOOKMARKS',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<Todo>>(
        stream: isarService.listenToBookmarks(), // Stream reaktif
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text(
                    'BELUM ADA PRODUK DISIMPAN',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final bookmarks = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Jumlah Bookmark
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${bookmarks.length} ITEMS',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('TERSIMPAN DI DATABASE ISAR', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: bookmarks.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemBuilder: (context, index) {
                    final item = bookmarks[index];
                    // Format waktu sesuai NIM Genap
                    final String timeFormatted = DateFormat('HH:mm').format(item.createdAt);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: Colors.white,
                            child: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        title: Text(
                          item.title.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Disimpan: $timeFormatted',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 20),
                            onPressed: () {
                              isarService.deleteBookmark(item.id); // Hapus data
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Produk dihapus dari database'),
                                  backgroundColor: primaryColor,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}