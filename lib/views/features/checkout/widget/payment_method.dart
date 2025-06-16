import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/product_controller.dart';
import 'package:mac_store_app/models/promo_code.dart';

class PaymentMethod extends ConsumerStatefulWidget {
  const PaymentMethod({
    super.key,
    required this.onChanged,
    required this.selectedPaymentMethod,
    required this.onPromoApplied,
    required this.onRemovePromo,
  });

  final ValueChanged<String> onChanged;
  final String selectedPaymentMethod;
  final ValueChanged<PromoCode> onPromoApplied;
  final VoidCallback onRemovePromo;

  @override
  ConsumerState<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends ConsumerState<PaymentMethod> {
  final TextEditingController _promoCodeController = TextEditingController();
  PromoCode? _appliedPromo;
  bool _isApplying = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _promoCodeController,
                decoration: InputDecoration(
                  hintText: 'Enter Promo Code',
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _isApplying
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      final code = _promoCodeController.text.trim();
                      if (code.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a promo code')),
                        );
                        return;
                      }

                      setState(() {
                        _isApplying = true;
                      });

                      try {
                        final promo =
                            await ProductController().getPromoCodeByCode(code);
                        setState(() {
                          _appliedPromo = promo;
                          _isApplying = false;
                        });
                        widget.onPromoApplied(promo);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Promo code applied: ${promo.discountValue}${promo.discountType == 'percentage' ? '%' : '\$'} off')),
                        );
                      } catch (e) {
                        setState(() {
                          _isApplying = false;
                          _appliedPromo = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Invalid or expired promo code. Error: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      backgroundColor: const Color(0xFF3854EE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
          ],
        ),
        if (_appliedPromo != null)
          Row(
            children: [
              Text(
                '✅ ${_appliedPromo!.code} applied - ${_appliedPromo!.discountValue}${_appliedPromo!.discountType == 'percentage' ? '%' : '\$'} OFF',
                style:
                    const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _appliedPromo = null;
                    _promoCodeController.clear();
                  });
                  widget.onRemovePromo();
                },
                child: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
        const SizedBox(height: 10),
        Text(
          'Choose Payment Method',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile<String>(
          title: Text(
            'Stripe',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold, fontSize: 18),
          ),
          value: 'stripe',
          groupValue: widget.selectedPaymentMethod,
          onChanged: (value) => widget.onChanged(value!),
        ),
        RadioListTile<String>(
          title: Text(
            'Cash on Delivery',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            ),
          ),
          value: 'cashOnDelivery',
          groupValue: widget.selectedPaymentMethod,
          onChanged: (value) => widget.onChanged(value!),
        ),
      ],
    );
  }
}
