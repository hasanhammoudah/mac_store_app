import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/provider/user_provider.dart';

class ShippingAddressScreen extends ConsumerStatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends ConsumerState<ShippingAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String state;
  late String city;
  late String locality;
  final AuthController _authController = AuthController();
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _localityController;

  @override
  void initState() {
    super.initState();
    // Read the current user state from the provider
    final user = ref.read(userProvider);
    //Initialize the controllers with the current data if available
    //if user data is not available, initialize with an empty string
    _stateController = TextEditingController(text: user?.state ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
    _localityController = TextEditingController(text: user?.locality ?? '');
  }

  _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(
                  'Updating...',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final updatedUser = ref.read(userProvider.notifier);
    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.96),
      backgroundColor: Colors.white.withValues(
        red: 255,
        green: 255,
        blue: 255,
        alpha: 0.96 * 255,
        colorSpace: ColorSpace.sRGB,
      ),
      appBar: AppBar(
        title: Text(
          'Delivery',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.7,
          ),
        ),
        backgroundColor: Colors.white.withValues(
          red: 255,
          green: 255,
          blue: 255,
          alpha: 0.96 * 255,
          colorSpace: ColorSpace.sRGB,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Where will your order\n be shipped',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.7,
                  ),
                ),
                TextFormField(
                  controller: _stateController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your state';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'State',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _cityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'City',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _localityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your locality';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Locality',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              _showLoadingDialog();
              try {
                await _authController.updateUserLocation(
                    context: context,
                    id: user!.id,
                    state: _stateController.text,
                    city: _cityController.text,
                    locality: _localityController.text,
                    ref: ref);

                updatedUser.recreateUserState(
                  state: _stateController.text,
                  city: _cityController.text,
                  locality: _localityController.text,
                );

                Navigator.pop(context); // Close loading dialog
                Navigator.pop(context); // Close screen
              } catch (e) {
                Navigator.pop(context); // Close loading dialog on error
                print('Error: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update location.')),
                );
              }
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(
                0xFF3854EE,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Save',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
