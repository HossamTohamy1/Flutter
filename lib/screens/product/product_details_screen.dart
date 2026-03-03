import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import 'add_edit_product_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              if (provider.selectedProduct == null) return const SizedBox.shrink();
              
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _navigateToEditProduct(context, provider.selectedProduct!),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDelete(context, provider.selectedProduct!.productId),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchProductById(widget.productId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.selectedProduct == null) {
            return const Center(child: Text('Product not found'));
          }

          final product = provider.selectedProduct!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey.shade200,
                          child: Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.image_not_supported, size: 80),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.shopping_bag, size: 80),
                        ),

                      // Product Information
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product.productName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Category
                            if (product.categoryName != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.categoryName!,
                                  style: TextStyle(
                                    color: Colors.purple.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),

                            // Price
                            Row(
                              children: [
                                const Icon(Icons.attach_money, color: Colors.green),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Stock
                            Row(
                              children: [
                                Icon(
                                  Icons.inventory,
                                  color: product.stock > 0 ? Colors.blue : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Stock: ${product.stock}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: product.stock > 0 ? Colors.blue : Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: product.stock > 0 
                                        ? Colors.green.shade50 
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    product.stock > 0 ? 'In Stock' : 'Out of Stock',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: product.stock > 0 
                                          ? Colors.green.shade700 
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Description
                            if (product.description != null && 
                                product.description!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.description!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade700,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 24),

                            // Created Date
                            if (product.createdAt != null)
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, 
                                      size: 16, 
                                      color: Colors.grey.shade600),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Created: ${_formatDate(product.createdAt!)}',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // ✅ Quantity Selector & Add to Cart Button (Fixed at bottom)
              if (product.stock > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Quantity Selector
                        Row(
                          children: [
                            const Text(
                              'Quantity:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    onPressed: _quantity > 1
                                        ? () => setState(() => _quantity--)
                                        : null,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      '$_quantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    onPressed: _quantity < product.stock
                                        ? () => setState(() => _quantity++)
                                        : null,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: !_isAddingToCart
                                ? () => _addToCart(product)
                                : null,
                            icon: _isAddingToCart
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.shopping_cart),
                            label: Text(
                              _isAddingToCart ? 'Adding...' : 'Add to Cart',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToEditProduct(BuildContext context, product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final provider = Provider.of<ProductProvider>(context, listen: false);
              final success = await provider.deleteProduct(productId);
              
              if (!mounted) return;
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.errorMessage ?? 'Failed to delete product'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ✅ Add to Cart Function
Future<void> _addToCart(product) async {
  setState(() {
    _isAddingToCart = true;
  });

  // جلب الـ userId من SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  if (userId == null) {
    setState(() {
      _isAddingToCart = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User not logged in!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final cartProvider = Provider.of<CartProvider>(context, listen: false);

  final success = await cartProvider.addToCart(
    userId,
    product.productId,
    _quantity,
  );

  setState(() {
    _isAddingToCart = false;
  });

  if (success && mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity ${product.productName} to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
    setState(() {
      _quantity = 1;
    });
  } else if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(cartProvider.errorMessage ?? 'Failed to add to cart'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
}