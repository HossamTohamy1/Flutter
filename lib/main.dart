import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/providers/category_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/order_provider.dart';

// Repositories
import 'package:ecommerce_app/repositories/category_repository.dart';
import 'package:ecommerce_app/repositories/product_repository.dart';
import 'package:ecommerce_app/repositories/cart_repository.dart';
import 'package:ecommerce_app/repositories/order_repository.dart';

// Screens
import 'package:ecommerce_app/screens/auth/login_screen.dart';
import 'package:ecommerce_app/screens/category/categories_screen.dart';
import 'package:ecommerce_app/screens/product/products_screen.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/order/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // User Provider
        ChangeNotifierProvider(create: (_) => UserProvider()),

        // Category Provider
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(CategoryRepository()),
        ),

        // Product Provider
        ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductRepository()),
        ),

        // Cart Provider - NEW
        ChangeNotifierProvider(
          create: (_) => CartProvider(CartRepository()),
        ),

        // Order Provider - NEW
        ChangeNotifierProvider(
          create: (_) => OrderProvider(OrderRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: Colors.purple,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),

        // Default Screen
        home: const LoginScreen(),

        // Routes
        routes: {
          '/categories': (_) => const CategoriesScreen(),
          '/products': (_) => const ProductsScreen(),
          '/cart': (_) => const CartScreen(),
          '/orders': (_) => const OrdersScreen(),
        },
      ),
    );
  }
}