import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/delivered_order_count_provider.dart';
import 'package:mac_store_app/provider/favorite_provider.dart' as j;
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:mac_store_app/views/screens/authentication_screen/login_screen.dart';
import 'package:mac_store_app/views/screens/authentication_screen/otp_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<void> signUpUsers({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: fullName,
        state: '',
        city: '',
        locality: '',
        email: email,
        password: password,
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse(
          '$uri/api/signup',
        ),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account created successfully');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OtpScreen(
              email: email,
            );
          }));
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print("Error:$e");
    }
  }

//sign in
  Future<void> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          '$uri/api/signin',
        ),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          //Access sharedPreferences for token and user data storage
          SharedPreferences preferences = await SharedPreferences.getInstance();
          String token = jsonDecode(response.body)['token'];
          //store token in shared preferences
          await preferences.setString('auth_token', token);
          //Encode the user data recieved from the backend as json
          String userJson = jsonEncode(jsonDecode(response.body));
          //update the application state with the user data using Riverpod
          ref.read(userProvider.notifier).setUser(response.body);

          //store the data in shared preferences for future
          await preferences.setString('user', userJson);

          showSnackBar(context, 'Login successful');
          if (ref.read(userProvider)!.token.isNotEmpty) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                (route) => false);
            showSnackBar(context, 'Logged in successfully');
          }
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print("Error:$e");
      showSnackBar(context, 'An error occurred while signing in');
    }
  }

  //SignOut
  Future<void> signOutUser({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // احذف كل البيانات المخزنة
      await prefs.clear();

      // أعد تعيين حالات Riverpod
      ref.read(userProvider.notifier).signOut();
      ref.read(deliveredOrderCountProvider.notifier).resetCount();
      ref.read(cartProvider.notifier).clearCart(); // امسح السلة
      ref.read(j.favoriteProvider.notifier).clearFavorites(); // امسح المفضلة

      // عد إلى شاشة تسجيل الدخول
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      showSnackBar(context, 'Sign out successfully');
    } catch (e) {
      print("Sign out error: $e");
      showSnackBar(context, 'Error signing out');
    }
  }

  // Update user's state,city and locality
  Future<void> updateUserLocation({
    required context,
    required String id,
    required String state,
    required String city,
    required String locality,
    required WidgetRef ref,
  }) async {
    try {
      http.Response response = await http.put(
        Uri.parse(
          '$uri/api/user/$id',
        ),
        body: jsonEncode(<String, String>{
          'state': state,
          'city': city,
          'locality': locality,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          final updatedUser = jsonDecode(response.body);
          // Access Shared preferences for local data storage
          // shared preferences allows us to store data locally on the device
          SharedPreferences preferences = await SharedPreferences.getInstance();
          // Encode the user data received from the backend as json
          final userJson = jsonEncode(updatedUser);
          // Update the application state with the user data using Riverpod
          ref.read(userProvider.notifier).setUser(userJson);
          // Store the data in shared preferences for future
          await preferences.setString('user', userJson);
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print("Error:$e");
    }
  }

  // Verify Otp Method
  Future<void> verifyOtp(
      {required BuildContext context,
      required String email,
      required String otp}) async {
    try {
      http.Response response = await http.post(Uri.parse('$uri/api/verify-otp'),
          body: jsonEncode(<String, String>{
            'email': email,
            'otp': otp,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false);
          showSnackBar(
              context, 'Account verified successfully, Please log in.');
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print("Error:$e");
      showSnackBar(context, 'An error occurred while verifying OTP');
    }
  }

  getUserData(context, WidgetRef ref) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        preferences.setString('auth_token', '');
      }
      var tokenResponse = await http.post(Uri.parse('$uri/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!
          });
      var response = jsonDecode(tokenResponse.body);
      if (response == true) {
        http.Response userResponse =
            await http.get(Uri.parse('$uri/'), headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        ref.read(userProvider.notifier).setUser(userResponse.body);
      }
    } catch (e) {
      print("Error:$e");
      showSnackBar(context, 'An error occurred while fetching user data');
    }
  }

  //Delete Account
  Future<void> deleteAccount(
      {required BuildContext context,
      required String id,
      required WidgetRef ref}) async {
    try {
      //Get the authentication token from shared preferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('auth_token');
      if (token == null) {
        showSnackBar(context, 'Please log in to delete your account');
        return;
      }
      //Send DELETE request to the backend
      http.Response response = await http.delete(
        Uri.parse('$uri/api/user/delete-account/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );
      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () async {
            //clear user data from sharedPref
            await preferences.remove('auth_token');
            await preferences.remove('user');
            //clear the user data from the provider state
            ref.read(userProvider.notifier).signOut();
            //Rediret to login screen after successful deletion
            showSnackBar(context, 'Account deleted successfully');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
          },
          onError: (e) {
            showSnackBar(context, e);
          });
    } catch (e) {
      print("Error:$e");
      showSnackBar(context, 'An error occurred while deleting account');
    }
  }
}
