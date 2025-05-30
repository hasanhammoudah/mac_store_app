import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/models/user.dart';

class UserProvider extends StateNotifier<User?> {
  // constructor initializing with default value User Object
  // purpose: Mange the state of the user object allowing updates
  UserProvider()
      : super(
          User(
            id: '',
            fullName: '',
            state: '',
            city: '',
            locality: '',
            email: '',
            password: '',
            token: '',
          ),
        );
  // Getter method to extract value from an object
  User? get user => state;
  //method to set user state from Json
  //purpose:updates he user state base on json string representation of user object
  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }

  void signOut() {
    state = null;
  }

  // method to Recreate the user state

  void recreateUserState({
    required String state,
    required String city,
    required String locality,
  }) {
    if (this.state != null) {
      this.state = User(
        id: this.state!.id,
        fullName: this.state!.fullName,
        state: this.state!.state,
        city: this.state!.city,
        locality: this.state!.locality,
        email: this.state!.email,
        password: this.state!.password,
        token: this.state!.token,
      );
   
    }
  }
}

// make the data accessible within the application
final userProvider = StateNotifierProvider<UserProvider, User?>((ref) {
  return UserProvider();
});
