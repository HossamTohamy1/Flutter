class Category {
  final int categoryId;
  final String categoryName;
  final String? description;
  final DateTime? createdAt;
  final int productCount;

  Category({
    required this.categoryId,
    required this.categoryName,
    this.description,
    this.createdAt,
    this.productCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      description: json['description'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      productCount: json['productCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'productCount': productCount,
    };
  }
}

class CreateCategoryRequest {
  final String categoryName;
  final String? description;

  CreateCategoryRequest({
    required this.categoryName,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'description': description,
    };
  }
}

class UpdateCategoryRequest {
  final String categoryName;
  final String? description;

  UpdateCategoryRequest({
    required this.categoryName,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'description': description,
    };
  }
}