class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;
  final int reviews;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.rating = 0.0,
    this.reviews = 0,
    this.isFavorite = false,
  });

  // من JSON (للـ API)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // لـ JSON (للـ API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'isFavorite': isFavorite,
    };
  }
}

// بيانات تجريبية (هنستبدلها بالـ API لاحقاً)
class DummyProducts {
  static List<Product> products = [
    Product(
      id: 1,
      name: 'Nike Air Max 270',
      description: 'The Nike Air Max 270 delivers visible cushioning',
      price: 150.00,
      image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      category: 'Shoes',
      rating: 4.8,
      reviews: 1250,
    ),
    Product(
      id: 2,
      name: 'Apple Watch Series 9',
      description: 'Advanced health and fitness features',
      price: 399.00,
      image: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=500',
      category: 'Electronics',
      rating: 4.9,
      reviews: 3200,
    ),
    Product(
      id: 3,
      name: 'Sony WH-1000XM5',
      description: 'Industry-leading noise canceling headphones',
      price: 349.00,
      image: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=500',
      category: 'Electronics',
      rating: 4.7,
      reviews: 890,
    ),
    Product(
      id: 4,
      name: 'Leather Backpack',
      description: 'Premium leather backpack for everyday use',
      price: 89.00,
      image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
      category: 'Bags',
      rating: 4.5,
      reviews: 450,
    ),
    Product(
      id: 5,
      name: 'Ray-Ban Sunglasses',
      description: 'Classic aviator sunglasses',
      price: 159.00,
      image: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=500',
      category: 'Accessories',
      rating: 4.6,
      reviews: 720,
    ),
    Product(
      id: 6,
      name: 'Samsung Galaxy Buds',
      description: 'True wireless earbuds with ANC',
      price: 129.00,
      image: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500',
      category: 'Electronics',
      rating: 4.4,
      reviews: 560,
    ),
  ];
}