import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/view/allpage.dart';
import 'package:flutter_application_1/view/cart/bottom_bar.dart';
import 'package:flutter_application_1/view/cart/cart_item.dart';
import 'package:flutter_application_1/view/cart/formorder.dart';
import 'package:flutter_application_1/view/home/homepage.dart';
import 'package:flutter_application_1/view/until/cart_ulti.dart';
import 'package:flutter_application_1/widgets/cart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageCart extends StatefulWidget {
  final Function(CartItemModel product) onProductTap;
  final ValueNotifier<int> cartitemCount;
  const PageCart({super.key, required this.onProductTap, required this.cartitemCount});

  @override
  State<PageCart> createState() => PageCartState();
}

class PageCartState extends State<PageCart> {
  List<CartItemModel> cartItems = [];
  bool isSelectAll = false;
  bool isLoading = true;

  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool get hasSelectedItems => cartItems.any((item) => item.isSelect);
  int get phiVanChuyen => hasSelectedItems ? 30000 : 0;

  String get tongThanhToan {
    final totalPrice = calculateTotalPrice(cartItems) + phiVanChuyen;
    return totalPrice.toStringAsFixed(0) + 'đ';
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await loadCartItems();
    emailController.text = Global.userId;
  }

  Future<void> loadCartItems() async {
    try {
      final items = await APIService.fetchCartItemsById(userId: Global.userId);
      setState(() {
        cartItems = items.map((e) => e..isSelect = false).toList();
        isSelectAll = false;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Lỗi khi load cart items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      isSelectAll = value ?? false;
      for (var item in cartItems) {
        item.isSelect = isSelectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CheckboxListTile(
                  title: const Text('Chọn tất cả'),
                  value: isSelectAll,
                  onChanged: toggleSelectAll,
                  activeColor: const Color(0xff0066FF),
                ),
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(child: Text("Giỏ hàng trống"))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 70),
                          itemCount: cartItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index == cartItems.length) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hasSelectedItems) ...[
                                      buildInfoRow(
                                          "Tiền đơn hàng",
                                          calculateTotalPrice(cartItems)
                                                  .toStringAsFixed(0) +
                                              "đ"),
                                      const SizedBox(height: 8),
                                      buildInfoRow(
                                          "Phí vận chuyển", '$phiVanChuyen'),
                                      const Divider(
                                          height: 20, color: Colors.black12),
                                      buildInfoRow(
                                          "Tổng thanh toán", tongThanhToan,
                                          isTotal: true),
                                    ]
                                  ],
                                ),
                              );
                            } else {
                              final item = cartItems[index];
                              return ItemCart(
                                cartitemCount: widget.cartitemCount,
                                userId: Global.userId,
                                item: item,
                                isSelected: item.isSelect,
                                onTap: () {
                                  widget.onProductTap(item);
                                },
                                onSelectedChanged: (value) {
                                  setState(() {
                                    item.isSelect = value ?? false;
                                    isSelectAll = cartItems
                                        .every((item) => item.isSelect);
                                  });
                                },
                                onIncrease: () {
                                  setState(() {
                                    item.quantity++;
                                  });
                                },
                                onDecrease: () {
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    }
                                  });
                                },
                                OnDeleted: () async {
                                  await loadCartItems();
                                },
                              );
                            }
                          }),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CartBottomBar(
                isOrderEnabled: hasSelectedItems,
                tongThanhToan: tongThanhToan,
                onOrderPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (BuildContext context) {
                      return OrderConfirmationSheet(
                        parentContext: context,
                        fullnameController: fullnameController,
                        phoneController: phoneController,
                        emailController: emailController,
                        tongThanhToan: tongThanhToan,
                        onConfirm: () async {
                          await handleDatHang(
                            cartitemCount: widget.cartitemCount,
                            context: context,
                            userId: Global.userId,
                            customerName: fullnameController.text,
                            email: emailController.text,
                            tel: phoneController.text,
                            cartItems: cartItems,
                            onCartReload: loadCartItems,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
