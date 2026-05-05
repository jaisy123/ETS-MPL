import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../../../../core/di/injection.dart';
import '../../data/isar_service.dart';
// Ganti baris 5 yang lama dengan ini:
import 'package:utd_store_jaisy/features/todo/domain/todo_model.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isarService = locator<IsarService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark Produk Jaisy'),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<List<Todo>>(
        stream: isarService.listenToBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Belum ada produk yang di-bookmark.'),
            );
          }

          final bookmarks = snapshot.data!;

          return ListView.builder(
            itemCount: bookmarks.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = bookmarks[index];
              final String timeFormatted = DateFormat('HH:mm').format(item.createdAt);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      // PERBAIKAN: Menggunakan satu underscore agar tidak error
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Disimpan pukul: $timeFormatted'), 
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      isarService.deleteBookmark(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bookmark dihapus')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}