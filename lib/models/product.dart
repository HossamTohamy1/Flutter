class Product {
  final int productId;
  final String productName;
  final String? description;
  final double price;
  final int stock;
  final int? categoryId;
  final String? categoryName;
  final String? imageUrl;
  final DateTime? createdAt;

  Product({
    required this.productId,
    required this.productName,
    this.description,
    required this.price,
    required this.stock,
    this.categoryId,
    this.categoryName,
    this.imageUrl,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'description': description,
      'price': price,
      'stock': stock,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

class PagedProducts {
  final List<Product> products;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  PagedProducts({
    required this.products,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  factory PagedProducts.fromJson(Map<String, dynamic> json) {
    return PagedProducts(
      products: (json['products'] as List)
          .map((p) => Product.fromJson(p))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}