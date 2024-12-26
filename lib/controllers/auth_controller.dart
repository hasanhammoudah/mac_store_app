import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mac_store_app/global_variables.dart';
import 'package:mac_store_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:mac_store_app/views/screens/authentication_screen/login_screen.dart';
import 'package:mac_store_app/views/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProviderContainer container = ProviderContainer();

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
            return const LoginScreen();
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
          String userJson = jsonEncode(jsonDecode(response.body)['user']);
          //update the application state with the user data using Riverpod
          container.read(userProvider.notifier).setUser(userJson);
          //store the data in shared preferences for future
          await preferences.setString('user', userJson);

          showSnackBar(context, 'Login successful');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
              (route) => false);
        },
        onError: (error) {
          showSnackBar(context, error);
        },
      );
    } catch (e) {
      print("Error:$e");
    }
  }

  //SignOut
  Future<void> signOutUser({required context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user');
      container.read(userProvider.notifier).signOut();
      //navigation the user back to the login screen
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }), (route) => false);
      showSnackBar(context, 'signout successfully');
    } catch (e) {
      showSnackBar(context, 'error signing out');
    }
  }
}
