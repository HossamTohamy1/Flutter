class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? address;
  final String? city;
  final String? country;
  final DateTime? joinedDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.address,
    this.city,
    this.country,
    this.joinedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      joinedDate: json['joinedDate'] != null 
          ? DateTime.parse(json['joinedDate']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'address': address,
      'city': city,
      'country': country,
      'joinedDate': joinedDate?.toIso8601String(),
    };
  }
}

class Order {
  final int id;
  final String orderNumber;
  final DateTime date;
  final String status;
  final double total;
  final int itemsCount;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.total,
    required this.itemsCount,
    required this.items,
  });

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'green';
      case 'processing':
        return 'blue';
      case 'shipped':
        return 'orange';
      case 'cancelled':
        return 'red';
      default:
        return 'grey';
    }
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      orderNumber: json['orderNumber'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      status: json['status'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      itemsCount: json['itemsCount'] ?? 0,
      items: (json['items'] as List?)
              ?.map((item) => OrderItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final double price;
  final String? image;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      image: json['image'],
    );
  }
}

// بيانات تجريبية
User dummyUser = User(
  id: 1,
  name: 'Ahmed Mohamed',
  email: 'ahmed.mohamed@example.com',
  phone: '+20 123 456 7890',
  avatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
  address: '123 Main Street, Apartment 4B',
  city: 'Cairo',
  country: 'Egypt',
  joinedDate: DateTime(2023, 6, 15),
);

List<Order> dummyOrders = [
  Order(
    id: 1,
    orderNumber: 'ORD-2024-001',
    date: DateTime.now().subtract(const Duration(days: 2)),
    status: 'Delivered',
    total: 549.00,
    itemsCount: 3,
    items: [
      OrderItem(
        productName: 'Nike Air Max 270',
        quantity: 1,
        price: 150.00,
        image: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200',
      ),
      OrderItem(
        productName: 'Apple Watch Series 9',
        quantity: 1,
        price: 399.00,
        image: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=200',
      ),
    ],
  ),
  Order(
    id: 2,
    orderNumber: 'ORD-2024-002',
    date: DateTime.now().subtract(const Duration(days: 5)),
    status: 'Processing',
    total: 349.00,
    itemsCount: 1,
    items: [
      OrderItem(
        productName: 'Sony WH-1000XM5',
        quantity: 1,
        price: 349.00,
        image: 'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=200',
      ),
    ],
  ),
  Order(
    id: 3,
    orderNumber: 'ORD-2024-003',
    date: DateTime.now().subtract(const Duration(days: 12)),
    status: 'Shipped',
    total: 248.00,
    itemsCount: 2,
    items: [
      OrderItem(
        productName: 'Leather Backpack',
        quantity: 1,
        price: 89.00,
        image: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=200',
      ),
      OrderItem(
        productName: 'Ray-Ban Sunglasses',
        quantity: 1,
        price: 159.00,
        image: 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=200',
      ),
    ],
  ),
];