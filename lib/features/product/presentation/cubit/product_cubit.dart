import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../domain/product_service.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _service;

  // Saat pertama kali dibuat, status langsung diatur ke Loading
  ProductCubit(this._service) : super(ProductLoading());

  Future<void> fetchAllProducts() async {
    emit(ProductLoading()); // Pasang indikator putar-putar
    
    try {
      // Memanggil service yang sudah ada delay 6 detik (Logika NIM 20123066)
      final data = await _service.fetchProducts();
      
      // Jika berhasil, pancarkan data ke UI
      emit(ProductLoaded(data));
    } catch (e) {
      // Jika gagal, pancarkan pesan error
      emit(ProductError('Gagal memuat produk: $e'));
    }
  }
}