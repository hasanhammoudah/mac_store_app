import 'package:mac_store_app/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/models/product_review.dart';
import 'package:mac_store_app/services/manage_http_response.dart';

class ProductReviewController {
  uploadReview({
    required String buyerId,
    required String email,
    required String fullName,
    required String productId,
    required double rating,
    required String review,
    required context,
  }) async {
    try {
      final ProductReview productReview = ProductReview(
        id: '',
        buyerId: buyerId,
        email: email,
        fullName: fullName,
        productId: productId,
        rating: rating,
        review: review,
      );
      final response = await http.post(
        Uri.parse('$uri/api/product-review'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: productReview.toJson(),
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Review added successfully');
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
