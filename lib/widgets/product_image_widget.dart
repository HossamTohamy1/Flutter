import 'package:flutter/material.dart';
import '../config/api_config.dart';

/// Reusable Product Image Widget with proper error handling
class ProductImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const ProductImageWidget({
    Key? key,
    this.imageUrl,
    this.width = 100,
    this.height = 100,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    final fullImageUrl = ApiConfig.getFullImageUrl(imageUrl);

    if (fullImageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        fullImageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Image loading error: $error');
          print('URL: $fullImageUrl');
          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.shopping_bag,
          size: width * 0.4,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}

/// Extension method for easy image URL handling
extension ImageUrlExtension on String? {
  String toFullImageUrl() {
    return ApiConfig.getFullImageUrl(this);
  }
  
  bool get isValidImageUrl {
    if (this == null || this!.isEmpty) return false;
    return this!.startsWith('http://') || 
           this!.startsWith('https://') ||
           this!.startsWith('/');
  }
}