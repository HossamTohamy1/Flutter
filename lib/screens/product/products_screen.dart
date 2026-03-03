import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/product.dart';
import 'add_edit_product_screen.dart';
import 'product_details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _addingToCartProducts = {}; // Track which products are being added

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts(refresh: true);
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          Provider.of<ProductProvider>(context, listen: false)
                              .searchProducts('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                Provider.of<ProductProvider>(context, listen: false)
                    .searchProducts(value);
              },
            ),
          ),

          // Products List
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.products.isEmpty) {
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
                          onPressed: () => provider.fetchProducts(refresh: true),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.products.isEmpty) {
                  return const Center(
                    child: Text('No products found'),
                  );
                }

                return Column(
                  children: [
                    // Filter Info
                    if (provider.selectedCategoryId != null || provider.searchTerm != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.blue.shade50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Filters active',
                                style: TextStyle(color: Colors.blue.shade900),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.clearFilters();
                              },
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                      ),

                    // Products Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: provider.products.length,
                        itemBuilder: (context, index) {
                          final product = provider.products[index];
                          return _buildProductCard(product);
                        },
                      ),
                    ),

                    // Pagination Controls
                    if (provider.totalPages > 1)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: provider.currentPage > 1
                                  ? () => provider.loadPreviousPage()
                                  : null,
                            ),
                            Text(
                              'Page ${provider.currentPage} of ${provider.totalPages}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: provider.currentPage < provider.totalPages
                                  ? () => provider.loadNextPage()
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddProduct(context),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final isAddingToCart = _addingToCartProducts.contains(product.productId);
    
    return GestureDetector(
      onTap: () => _navigateToProductDetails(context, product.productId),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported, size: 50),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.shopping_bag, size: 50),
                          ),
                  ),
                  // Stock Badge
                  if (product.stock <= 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (product.categoryName != null)
                      Text(
                        product.categoryName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // ✅ Quick Add to Cart Button
                        if (product.stock > 0)
                          InkWell(
                            onTap: isAddingToCart ? null : () => _quickAddToCart(product),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: isAddingToCart
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter by Category:'),
            const SizedBox(height: 10),
            DropdownButton<int?>(
              value: productProvider.selectedCategoryId,
              isExpanded: true,
              hint: const Text('All Categories'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...categoryProvider.categories.map((category) {
                  return DropdownMenuItem<int?>(
                    value: category.categoryId,
                    child: Text(category.categoryName),
                  );
                }),
              ],
              onChanged: (value) {
                Navigator.pop(context);
                productProvider.filterByCategory(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              productProvider.clearFilters();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditProductScreen()),
    );
  }

  void _navigateToProductDetails(BuildContext context, int productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    );
  }

  // ✅ Quick Add to Cart (adds 1 item)
  Future<void> _quickAddToCart(Product product) async {
    setState(() {
      _addingToCartProducts.add(product.productId);
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.userId ?? '1';
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final success = await cartProvider.addToCart(userId, product.productId, 1);

    setState(() {
      _addingToCartProducts.remove(product.productId);
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.productName} added to cart'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
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