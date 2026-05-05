import 'package:isar/isar.dart';

// Bagian ini akan error sebelum kita menjalankan build_runner, abaikan saja dulu
part 'todo_model.g.dart';

@collection
class Todo {
  Id id = Isar.autoIncrement; // ID otomatis dari Isar

  late String title;
  late String imageUrl;
  
  // LOGIKA PERSONAL: Menyimpan waktu saat tombol bookmark ditekan
  late DateTime createdAt; 

  bool isCompleted = false;
}