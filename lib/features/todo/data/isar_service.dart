import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/todo_model.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [TodoSchema], // Menggunakan skema yang dihasilkan build_runner[cite: 6]
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // Fungsi menyimpan Bookmark dengan Timestamp
  Future<void> saveBookmark(String title, String imageUrl) async {
    final isar = await db;
    final newTodo = Todo()
      ..title = title
      ..imageUrl = imageUrl
      ..createdAt = DateTime.now(); // LOGIKA PERSONAL: Simpan waktu sekarang[cite: 8]

    isar.writeTxnSync(() => isar.todos.putSync(newTodo));
  }

  // Fungsi menghapus Bookmark[cite: 6]
  Future<void> deleteBookmark(Id id) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todos.deleteSync(id));
  }

  // STREAM REAKTIF: UI akan otomatis update tanpa setState
  Stream<List<Todo>> listenToBookmarks() async* {
    final isar = await db;
    yield* isar.todos.where().watch(fireImmediately: true);
  }
}