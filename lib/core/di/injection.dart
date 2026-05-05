import 'package:get_it/get_it.dart';
import '../network/api_client.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/product/domain/product_service.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/todo/data/isar_service.dart';

// Inisialisasi sang 'Pelayan' secara global
final locator = GetIt.instance;

void setupLocator() {
  // 1. Daftarkan API Client (Dio) sebagai Singleton[cite: 1]
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // 2. Daftarkan Isar Service untuk Database Lokal[cite: 6]
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Daftarkan Repository Produk
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());

  // 4. Daftarkan Service Produk (Jembatan Logika)
  locator.registerFactory<ProductService>(() => ProductService(locator()));

  // 5. Daftarkan Cubit untuk State Management[cite: 2]
  // registerFactory digunakan agar Cubit selalu baru setiap kali dipanggil[cite: 2]
  locator.registerFactory<ProductCubit>(() => ProductCubit(locator()));
}