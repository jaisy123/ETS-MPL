class Product {
  final String id;
  final String name;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    
    // Penyesuaian format gambar agar fleksibel sesuai modul[cite: 1, 6]
    if (json['image'] != null) {
      imageUrl = json['image'].toString();
    } else if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0].toString();
      imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '').replaceAll('"', '');
    }

    return Product(
      id: json['id'].toString(),
      // Kita biarkan name murni di sini, manipulasi NIM dilakukan di Repository
      name: json['title'] ?? 'Tanpa Nama', 
      image: imageUrl.isNotEmpty ? imageUrl : 'https://via.placeholder.com/150',
    );
  }

  // Method copyWith ini sangat berguna saat manipulasi data di Repository nanti
  Product copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}