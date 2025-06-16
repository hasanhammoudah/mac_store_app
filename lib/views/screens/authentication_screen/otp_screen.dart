import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/services/manage_http_response.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});
  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  bool isLoading = false;
  List<String> otpDigits = List.filled(6, '');
  void verifyOtp() async {
    if (otpDigits.contains('')) {
      showSnackBar(context, 'please fill in all OTP fields');
      return;
    }
    setState(() {
      isLoading = true;
    });
    final otp = otpDigits.join();
    await _authController
        .verifyOtp(
      context: context,
      email: widget.email,
      otp: otp,
    )
        .then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, error.toString());
    });
  }

  Widget buildOtpField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty && value.length == 1) {
            otpDigits[index] = value;

            //automatically move to the next field
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          }
        },
        onFieldSubmitted: (value) {
          if (index == 5 && _formKey.currentState!.validate()) {
            verifyOtp();
          } else if (value.isEmpty) {
            otpDigits[index] = '';
            FocusScope.of(context).previousFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Verify Your Account',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: const Color(0xFF0d120E),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter the OTP sent to ${widget.email}",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: const Color(0xFF0d120E),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, buildOtpField),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      verifyOtp();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF103DE5),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Verify',
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
