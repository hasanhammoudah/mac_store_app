import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/cart.dart';

//Define a StateNotifierProvider to expose an instance of the CartNotifier class
//Making it accessible within the application
final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});
// A Notifier class to manage the cart state, extending stateNotifier
//With an initial state of an empty map

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({});

  //Method to add a product to the cart
  void addProductToCart({
    required String productName,
    required String category,
    required List<String> image,
    required int productPrice,
    required String vendorId,
    required int productQuantity,
    required int quantity,
    required String productId,
    required String description,
    required String fullName,
  }) {
    //Check if the product is already in the cart
    if (state.containsKey(productId)) {
      //If the product is already in the cart, update the quantity
      state = {
        ...state,
        productId: Cart(
          productName: state[productId]!.productName,
          category: state[productId]!.category,
          image: state[productId]!.image,
          productPrice: state[productId]!.productPrice,
          vendorId: state[productId]!.vendorId,
          productQuantity: state[productId]!.productQuantity,
          quantity: state[productId]!.quantity + quantity,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
          fullName: state[productId]!.fullName,
        ),
      };

      // state.update(productId, (value) {
      //   return Cart(
      //     productName: productName,
      //     category: category,
      //     image: image,
      //     productPrice: productPrice,
      //     vendorId: vendorId,
      //     productQuantity: productQuantity,
      //     quantity: value.quantity + quantity,
      //     productId: productId,
      //     description: description,
      //     fullName: fullName,
      //   );
      // });
    } else {
      //If the product is not in the cart, add it to the cart
      state = {
        ...state,
        productId: Cart(
          productName: productName,
          category: category,
          image: image,
          productPrice: productPrice,
          vendorId: vendorId,
          productQuantity: productQuantity,
          quantity: quantity,
          productId: productId,
          description: description,
          fullName: fullName,
        ),
      };
      // state.putIfAbsent(
      //   productId,
      //   () => Cart(
      //     productName: productName,
      //     category: category,
      //     image: image,
      //     productPrice: productPrice,
      //     vendorId: vendorId,
      //     productQuantity: productQuantity,
      //     quantity: quantity,
      //     productId: productId,
      //     description: description,
      //     fullName: fullName,
      //   ),
      // );
    }
  }

  //Method to increase the quantity of a product in the cart
  void increaseQuantity(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;
      //Notify listeners that the state has changed
      state = {...state};
    }
  }

  // Method to decrement the quantity of a product in the cart
  void decreaseQuantity(String productId) {
    if (state.containsKey(productId)) {
      if (state[productId]!.quantity > 1) {
        state[productId]!.quantity--;
        //Notify listeners that the state has changed
        state = {...state};
      }
    }
  }

  //Method to remove a product from the cart
  void removeProductFromCart(String productId) {
    state.remove(productId);
    //Notify listeners that the state has changed
    state = {...state};
  }

  //Method to calculate the total price of the products in the cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.productPrice * cartItem.quantity;
    });
    return totalAmount;
  }
}
