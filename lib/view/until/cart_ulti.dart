import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/view/home/homepage.dart';
import 'package:flutter_application_1/view/until/until.dart';

double calculateTotalPrice(List<CartItemModel> cartItems) {
  double total = 0;
  for (var item in cartItems) {
    if (item.isSelect) {
      total += item.price * item.quantity;
    }
  }
  return total;
}

Future<void> handleDatHang({
  required BuildContext context,
  required String userId,
  required String customerName,
  required String email,
  required String tel,
  required List<CartItemModel> cartItems,
  required Future<void> Function() onCartReload,
  required ValueNotifier<int> cartitemCount
}) async {
  try {
    await APIService.datHang(
      customerName: customerName,
      email: email,
      tel: tel,
    );

    // Lấy các item đã chọn
    final selectedItems = cartItems.where((item) => item.isSelect).toList();

    // ✅ Lưu vào lịch sử mua hàng (theo từng user)
    await APIService.saveOrderHistory(Global.userId, selectedItems);

    // ✅ Xóa các item đã chọn khỏi giỏ hàng
    for (var item in selectedItems) {
      await APIService.removeCartItem(
        cartitemCount: cartitemCount,
        userId: userId,
        productId: item.id.toString(),
      );
    }

    await onCartReload();
    Navigator.pop(context);
    showNotification(
      context,
      'Cảm ơn bạn đã đặt hàng! Đơn đặt hàng đã được chuyển đi, chúng tôi sẽ liên hệ với quý khách sớm nhất',
      Colors.green,
    );
  } catch (e) {
    print("❌ Lỗi khi đặt hàng: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đặt hàng thất bại")),
    );
  }
}
