import 'package:mac_store_app/models/product.dart';
import 'package:share_plus/share_plus.dart';

void shareProductDetails(Product product) {
  final priceText = product.hasDiscount && product.discountedPrice != null
      ? "\$${product.discountedPrice!.toStringAsFixed(2)} (was \$${product.productPrice.toStringAsFixed(2)})"
      : "\$${product.productPrice.toStringAsFixed(2)}";

  final String message = '''
🛍️ Check out this product: ${product.productName}
💰 Price: $priceText
📝 Description: ${product.description}

🔗 View more: https://yourshop.com/products/${product.id}
''';

  Share.share(message);
}
