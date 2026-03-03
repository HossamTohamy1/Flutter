class OrderItem {
  final int orderItemId;
  final int productId;
  final String productName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.orderItemId,
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: json['orderItemId'] ?? 0,
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
    );
  }
}

class Order {
  final int orderId;
  final String userId;
  final DateTime? orderDate;
  final double totalAmount;
  final String status;
  final String? shippingAddress;
  final String? paymentMethod;
  final String? paymentStatus;
  final List<OrderItem> items;

  Order({
    required this.orderId,
    required this.userId,
    this.orderDate,
    required this.totalAmount,
    required this.status,
    this.shippingAddress,
    this.paymentMethod,
    this.paymentStatus,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] ?? 0,
      userId: json['userId'] ?? '',
      orderDate: json['orderDate'] != null 
          ? DateTime.parse(json['orderDate']) 
          : null,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OrderSummary {
  final int orderId;
  final DateTime? orderDate;
  final double totalAmount;
  final String status;
  final int itemCount;

  OrderSummary({
    required this.orderId,
    this.orderDate,
    required this.totalAmount,
    required this.status,
    required this.itemCount,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      orderId: json['orderId'] ?? 0,
      orderDate: json['orderDate'] != null 
          ? DateTime.parse(json['orderDate']) 
          : null,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      itemCount: json['itemCount'] ?? 0,
    );
  }
}