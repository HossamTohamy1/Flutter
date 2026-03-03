import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/product_image_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String userId;
  final int orderId;

  const OrderDetailsScreen({
    super.key,
    required this.userId,
    required this.orderId,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _isUpdatingPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrderDetails();
    });
  }

  void _loadOrderDetails() {
    Provider.of<OrderProvider>(context, listen: false)
        .loadOrderDetails(widget.userId, widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOrderDetails,
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      orderProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadOrderDetails,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (orderProvider.selectedOrder == null) {
            return const Center(child: Text('Order not found'));
          }

          final order = orderProvider.selectedOrder!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status Timeline
                _buildStatusTimeline(order.status),
                const SizedBox(height: 24),

                // Order Information
                _buildOrderInfo(order),
                const SizedBox(height: 24),

                // Order Items
                _buildOrderItems(order),
                const SizedBox(height: 24),

                // Payment Summary
                _buildPaymentSummary(order),
                const SizedBox(height: 24),

                // ✅ Order Actions
                _buildOrderActions(order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusTimeline(String currentStatus) {
    final statuses = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    final currentIndex = statuses.indexWhere(
      (s) => s.toLowerCase() == currentStatus.toLowerCase(),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(statuses.length, (index) {
                final isActive = index <= currentIndex;
                final isCompleted = index < currentIndex;

                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.purple : Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCompleted ? Icons.check : Icons.circle,
                                color: Colors.white,
                                size: isCompleted ? 24 : 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              statuses[index],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                color: isActive ? Colors.purple : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      if (index < statuses.length - 1)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: isCompleted ? Colors.purple : Colors.grey.shade300,
                            margin: const EdgeInsets.only(bottom: 32),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Order Date', _formatDate(order.orderDate)),
            _buildInfoRow('Payment Method', order.paymentMethod ?? 'N/A'),
            _buildInfoRow('Payment Status', order.paymentStatus ?? 'N/A',
                valueColor: _getPaymentStatusColor(order.paymentStatus)),
            const Divider(height: 24),
            const Text(
              'Shipping Address',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              order.shippingAddress ?? 'N/A',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(order) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items (${order.items.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            ...order.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Product Image
                    ProductImageWidget(
                      imageUrl: item.imageUrl,
                      width: 70,
                      height: 70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    const SizedBox(width: 12),
                    
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item.unitPrice.toStringAsFixed(2)} each',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Item Total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${item.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(order) {
    return Card(
      elevation: 2,
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Order Action Buttons
  Widget _buildOrderActions(order) {
    final canUpdatePayment = order.paymentStatus?.toLowerCase() == 'pending';
    final canCancelOrder = order.status.toLowerCase() == 'pending';

    if (!canUpdatePayment && !canCancelOrder) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Mark as Paid Button
            if (canUpdatePayment)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isUpdatingPayment ? null : () => _updatePaymentStatus('Paid'),
                  icon: _isUpdatingPayment
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.payment),
                  label: Text(_isUpdatingPayment ? 'Updating...' : 'Mark as Paid'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            
            if (canUpdatePayment && canCancelOrder)
              const SizedBox(height: 12),
            
            // Cancel Order Button
            if (canCancelOrder)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmCancelOrder(order.orderId),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Order'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getPaymentStatusColor(String? status) {
    if (status == null) return Colors.grey;
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // ✅ Update Payment Status
  Future<void> _updatePaymentStatus(String status) async {
    setState(() {
      _isUpdatingPayment = true;
    });

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.updatePaymentStatus(widget.orderId, status);

    setState(() {
      _isUpdatingPayment = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      _loadOrderDetails(); // Reload order details
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage ?? 'Failed to update payment status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ Confirm Cancel Order
  void _confirmCancelOrder(int orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, Keep Order'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Note: You would need to add a cancelOrder method in your OrderProvider/Repository
              _showCancelNotImplemented();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel Order'),
          ),
        ],
      ),
    );
  }

  void _showCancelNotImplemented() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order cancellation feature will be implemented in the API'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}