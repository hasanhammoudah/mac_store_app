import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewStateNotifier extends StateNotifier<Set<String>> {
  ReviewStateNotifier() : super({}); 

  void markReviewed(String orderId) {
    state = {...state, orderId};
  }

  bool isReviewed(String orderId) {
    return state.contains(orderId);
  }
}

final reviewStateProvider =
    StateNotifierProvider<ReviewStateNotifier, Set<String>>((ref) {
  return ReviewStateNotifier();
});
