import 'package:ecommerce_app/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }
}

class Cart {
  final List<CartItem> items = [];

  // Add product to cart
  void addProduct(Product product, {int quantity = 1}) {
    // Check if product already exists
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      // Update quantity
      items[existingIndex].quantity += quantity;
    } else {
      // Add new item
      items.add(CartItem(product: product, quantity: quantity));
    }
  }

  // Remove product from cart
  void removeProduct(int productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  // Update quantity
  void updateQuantity(int productId, int quantity) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeProduct(productId);
      } else {
        items[index].quantity = quantity;
      }
    }
  }

  // Clear cart
  void clear() {
    items.clear();
  }

  // Get total items count
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get subtotal
  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Get shipping cost
  double get shipping {
    return subtotal > 0 ? 10.0 : 0.0; // Free shipping above certain amount
  }

  // Get tax (10%)
  double get tax {
    return subtotal * 0.10;
  }

  // Get total
  double get total {
    return subtotal + shipping + tax;
  }

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;
}

// Global cart instance (سنستخدم Provider لاحقاً)
final Cart globalCart = Cart();