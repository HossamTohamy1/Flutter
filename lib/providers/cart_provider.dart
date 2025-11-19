import 'package:flutter/foundation.dart';
import 'package:ecommerce_app/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Get total items count
  int get itemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Get subtotal
  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Get shipping cost
  double get shipping {
    return subtotal > 0 ? 10.0 : 0.0;
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
  bool get isEmpty => _items.isEmpty;

  // Check if product is in cart
  bool isInCart(int productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Get product quantity in cart
  int getProductQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }

  // Add product to cart
  void addProduct(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      // Update quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // Add new item
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  // Remove product from cart
  void removeProduct(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  // Update quantity
  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    
    if (index >= 0) {
      if (quantity <= 0) {
        removeProduct(productId);
      } else {
        _items[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  // Increase quantity
  void increaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // Decrease quantity
  void decreaseQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        removeProduct(productId);
      }
    }
  }

  // Clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }
}