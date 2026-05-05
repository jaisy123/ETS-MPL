import '../data/product_repository.dart';
import 'product_model.dart';

class ProductService {
  final ProductRepository repository;

  ProductService(this.repository);

  // Fungsi untuk mengambil daftar produk dengan logika delay personal
  Future<List<Product>> fetchProducts() async {
    // LOGIKA PERSONAL (ANTI-AI):
    // Aplikasi wajib melakukan delay selama X detik (Digit terakhir NIM).
    // NIM Jaisy: 20123066 -> Delay 6 detik.
    // Delay ini diletakkan di level Service sesuai instruksi ETS.
    await Future.delayed(const Duration(seconds: 6)); 

    return await repository.getAllProducts();
  }

  // Fungsi untuk mengambil detail produk tunggal
  Future<Product?> fetchProductDetail(String id) async {
    // Memanggil repository untuk mencari satu produk berdasarkan ID
    return await repository.getProductById(id);
  }
}