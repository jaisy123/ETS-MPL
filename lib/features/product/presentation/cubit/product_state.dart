import 'package:equatable/equatable.dart';
import '../../domain/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

// 1. Status saat sedang mengambil data dari API
class ProductLoading extends ProductState {}

// 2. Status saat data berhasil didapat (Membawa list produk)
class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

// 3. Status saat terjadi error (Membawa pesan error)
class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}