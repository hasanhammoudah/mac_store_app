import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_store_app/controllers/auth_controller.dart';
import 'package:mac_store_app/provider/cart_provider.dart';
import 'package:mac_store_app/provider/delivered_order_count_provider.dart';
import 'package:mac_store_app/provider/favorite_provider.dart';
import 'package:mac_store_app/provider/order_provider.dart';
import 'package:mac_store_app/provider/user_provider.dart';
import 'package:mac_store_app/services/manage_http_response.dart';
import 'package:mac_store_app/views/features/checkout/widget/shipping_address_screen.dart';
import 'package:mac_store_app/views/features/orders/view/order_screen.dart';

class AccountScreen extends ConsumerStatefulWidget {
  AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final AuthController _authController = AuthController();

  //show signout dialog
  void _showSignOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Sign Out',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: Text(
              'Are you sure you want to sign out?',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade700,
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style:
                      GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await _authController.signOutUser(context: context, ref: ref);
                  // Navigator.of(context).pushReplacementNamed('/login');
                  // showSnackBar(context, 'Logout Successfully');
                },
                child: Text(
                  'Sign Out',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    if (user == null) {
      return const Center(
          child: CircularProgressIndicator()); // أو واجهة تسجيل الدخول
    }
    final buyerId = user.id;

    final cartData = ref.read(cartProvider);
    final favoriteCount = ref.read(favoriteProvider);
    ref.read(deliveredOrderCountProvider.notifier).fetchedDeliveredOrderCount(
          user!.id,
          context,
        );
    final deliveredCount = ref.watch(deliveredOrderCountProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ✅ خلفية زرقاء
                  Positioned.fill(
                    child: Image.network(
                      'https://img.freepik.com/free-vector/gradient-blue-abstract-technology-background_23-2149213765.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // ✅ أيقونة الإشعارات
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Image.asset(
                      'assets/icons/not.png',
                      width: 30,
                      height: 30,
                    ),
                  ),

                  // ✅ صورة البروفايل مع أيقونة التعديل
                  Align(
                    alignment: const Alignment(0, -0.53),
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 65,
                          backgroundImage:
                              NetworkImage("https://i.pravatar.cc/150?img=3"),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/icons/edit.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ اسم المستخدم
                  Align(
                    alignment: const Alignment(0, 0.03),
                    child: user!.fullName != ""
                        ? Text(
                            user.fullName,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            'User',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  // ✅ الموقع
                  Align(
                    alignment: const Alignment(0, 0.17),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ShippingAddressScreen();
                        }));
                      },
                      child: user.state != ''
                          ? Text(
                              user.state,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.7,
                              ),
                            )
                          : Text(
                              'State',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.7,
                              ),
                            ),
                    ),
                  ),
                  // ✅ Favorite + Completed + Orders
                  Align(
                    alignment: const Alignment(0, 0.81),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileStatBox(
                          title: "Cart",
                          count: cartData.length.toString(),
                          imageUrl:
                              'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=800&q=80',
                        ),
                        _buildProfileStatBox(
                          title: "Completed",
                          count: deliveredCount.toString(),
                          imageUrl:
                              'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=800&q=80',
                        ),
                        _buildProfileStatBox(
                          title: "Favorite",
                          count: favoriteCount.length.toString(),
                          imageUrl:
                              'https://images.unsplash.com/photo-1503264116251-35a269479413?auto=format&fit=crop&w=800&q=80',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderScreen();
                }));
              },
              leading: Image.asset('assets/icons/orders.png'),
              title: Text(
                'Track your order',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const OrderScreen();
                }));
              },
              leading: Image.asset('assets/icons/history.png'),
              title: Text(
                'History',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {},
              leading: Image.asset('assets/icons/help.png'),
              title: Text(
                'Help',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () async {
                await _authController.deleteAccount(
                  id: user.id,
                  context: context,
                  ref: ref,
                );
              },
              leading: Image.asset('assets/icons/delete.png'),
              title: Text(
                'Delete Account',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                _showSignOutDialog(context);
              },
              leading: Image.asset('assets/icons/logout.png'),
              title: Text(
                'Logout',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ العنصر الموحد لكل مربع (Favorite, Completed, Orders)
  Widget _buildProfileStatBox({
    required String title,
    required String count,
    required String imageUrl,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 58,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 13,
                top: 18,
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1AKF7LelsXtbK8YAYYdiPrDMZdFd74ZTgkQ&s",
                  width: 26,
                  height: 26,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}
