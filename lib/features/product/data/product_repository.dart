import 'package:dio/dio.dart';
import '../domain/product_model.dart';
import '../../../../core/di/injection.dart'; 
import '../../../../core/network/api_client.dart'; 

class ProductRepository {
  // Ambil ApiClient (Dio) dari Pelayan (get_it)[cite: 3]
  final ApiClient _apiClient = locator<ApiClient>();

  // Fungsi mengambil semua produk[cite: 1]
  Future<List<Product>> getAllProducts() async {
    try {
      // Endpoint API publik[cite: 1]
      final response = await _apiClient.dio.get('/products');
      
      final List<dynamic> jsonList = response.data;
      
      return jsonList.map((json) {
        final product = Product.fromJson(json);

        // LOGIKA PERSONAL NIM GENAP (NIM: 20123066 -> 6)
        // Wajib menambahkan teks [Promo Ongkir] sesuai instruksi ETS
        return product.copyWith(
          name: "${product.name} [Promo Ongkir]",
        );
      }).toList();
    } on DioException catch (e) {
      // Penanganan error jaringan[cite: 1]
      throw Exception('Gagal memuat jaringan: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan sistem: $e');
    }
  }

  // Ambil 1 produk berdasarkan ID untuk konsistensi di halaman detail[cite: 3, 8]
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _apiClient.dio.get('/products/$id');
      final product = Product.fromJson(response.data);

      // LOGIKA PERSONAL: Tambahkan label yang sama agar seragam
      return product.copyWith(
        name: "${product.name} [Promo Ongkir]",
      );
    } catch (e) {
      return null;
    }
  }
}