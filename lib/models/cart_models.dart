class CartItem {
  final int cartItemId;
  final int productId;
  final String productName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final int stock;

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.stock,
  });

  double get totalPrice => quantity * unitPrice;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemId': cartItemId,
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'stock': stock,
    };
  }
}

class Cart {
  final int cartId;
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.cartId,
    required this.userId,
    required this.items,
  });

  double get subTotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'] ?? 0,
      userId: json['userId'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}