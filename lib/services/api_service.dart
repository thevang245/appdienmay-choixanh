import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/view/until/until.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  static const String baseUrl = 'https://choixanh.com.vn';
  static const String loginUrl = '$baseUrl/ww1/userlogin.asp';

  static Future<List<dynamic>> fetchProductsByCategory({
    required int categoryId,
    required String ww2,
    required String product,
    required String extention,
  }) async {
    late Uri uri;

    if (categoryId == 0) {
      uri = Uri.parse('${baseUrl}/ww2/module.sanpham.trangchu.asp').replace(
        queryParameters: {
          'id': '35279',
        },
      );
    } else {
      uri = Uri.parse('$baseUrl/$ww2/$extention.$product.asp').replace(
        queryParameters: {
          'id': categoryId.toString(),
          'sl': '30',
          'pageid': '1',
        },
      );
    }

    print('Gọi API URL: $uri');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        /// ✅ Trường hợp phản hồi là List và có phần tử đầu tiên là Map chứa key "data"
        if (decoded is List && decoded.isNotEmpty) {
          final first = decoded[0];
          if (first is Map && first.containsKey('data')) {
            return first['data'];
          } else {
            print('Không tìm thấy key "data" trong phần tử đầu tiên.');
            return [];
          }
        } else {
          print('Phản hồi không phải List hoặc rỗng');
          return [];
        }
      } else {
        print('Lỗi server: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi kết nối hoặc xử lý API: $e');
      return [];
    }
  }

  static Future<List<dynamic>> loadComments() async {
    final uri = Uri.parse('$baseUrl/ww2/module.tintuc.asp').replace(
      queryParameters: {
        'id': '35281',
      },
    );

    print('Link comment: $uri');
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        print('Phản hồi JSON gốc: ${response.body}');

        if (decoded is List && decoded.isNotEmpty) {
          final first = decoded[0];
          if (first is Map && first.containsKey('data')) {
            final dataList = first['data'];
            if (dataList is List) {
              print('Số comment nhận được: ${dataList.length}');
              return dataList;
            }
          }
        }
        return [];
      } else {
        print('Lỗi server khi tải comment: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Lỗi khi gọi API loadComments: $e');
      return [];
    }
  }

  static Future<bool> addToCart({
    required String userId,
    required String passwordHash,
    required int productId,
    required String tieude,
    required String gia,
    required String hinhdaidien,
  }) async {
    final uri = Uri.parse('$baseUrl/ww1/save.addcart.asp').replace(
      queryParameters: {
        'userid': userId,
        'pass': passwordHash,
        'id': productId.toString(),
      },
    );

    print('Gọi API Thêm vào giỏ hàng: $uri');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = response.body.trim();
        print('Phản hồi Thêm giỏ hàng: $decoded');

        try {
          final jsonResponse = json.decode(decoded);
          if (jsonResponse is List && jsonResponse.isNotEmpty) {
            final maloi = jsonResponse[0]['maloi'];
            if (maloi == '1') {
              // ✅ Thêm thành công => lưu vào SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              final key = 'cart_items_$userId';
              List<String> cartItems = prefs.getStringList(key) ?? [];

// Parse lại từng item để kiểm tra id
              bool exists = false;
              for (var itemStr in cartItems) {
                try {
                  final itemMap = json.decode(itemStr);
                  if (itemMap['id'] == productId.toString()) {
                    exists = true;
                    break;
                  }
                } catch (e) {
                  // Nếu lỗi decode thì bỏ qua
                }
              }

              if (!exists) {
                final itemMap = {
                  'id': productId.toString(),
                  'tieude': tieude,
                  'gia': gia,
                  'hinhdaidien': hinhdaidien,
                };
                final itemJsonString = json.encode(itemMap);

                cartItems.add(itemJsonString);
                await prefs.setStringList(key, cartItems);
                print(
                    '✅ Đã lưu sản phẩm vào SharedPreferences (JSON): $itemJsonString');
                return true;
              } else {
                print('⚠️ Sản phẩm đã tồn tại trong giỏ, không thêm nữa');
                return false;
              }
            } else {
              print('❌ Thêm giỏ hàng thất bại, mã lỗi: $maloi');
              return false;
            }
          } else {
            print('❌ Phản hồi không đúng định dạng List hoặc rỗng');
            return false;
          }
        } catch (e) {
          print('❌ Phản hồi không phải JSON hoặc lỗi decode: $e');
          return false;
        }
      } else {
        print('❌ Lỗi server khi thêm giỏ hàng: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Lỗi kết nối hoặc xử lý thêm giỏ hàng: $e');
      return false;
    }
  }

  static Future<List<CartItemModel>> fetchCartItemsById({
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cart_items_$userId';
    final List<String> cartItems = prefs.getStringList(key) ?? [];

    print("🟡 Danh sách dữ liệu lấy từ SharedPreferences ($key):");
    for (var i = 0; i < cartItems.length; i++) {
      print("[$i] ➤ ${cartItems[i]}");
    }

    List<CartItemModel> items = [];

    for (var itemStr in cartItems) {
      try {
        final Map<String, dynamic> jsonData = json.decode(itemStr);

        print("✅ Parsed JSON: $jsonData");

        items.add(CartItemModel(
          id: jsonData['id'].toString(),
          name: jsonData['tieude'] ?? '',
          price: double.tryParse(jsonData['gia'].toString()) ?? 0,
          image: jsonData['hinhdaidien'] ?? '',
          quantity: int.tryParse(jsonData['soluong']?.toString() ?? '1') ?? 1,
        ));
      } catch (e) {
        print('❌ Lỗi decode item trong SharedPreferences: $e');
      }
    }

    return items;
  }

  static Future<bool> removeCartItem({
    required String userId,
    required String productId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'cart_items_$userId';
    List<String> cartItems = prefs.getStringList(key) ?? [];

    // Lọc ra những item không khớp với id cần xóa
    cartItems.removeWhere((itemStr) {
      try {
        final item = json.decode(itemStr);
        return item['id'].toString() == productId;
      } catch (e) {
        // Nếu lỗi khi decode thì bỏ qua (không xóa)
        return false;
      }
    });

    // Lưu lại danh sách mới
    return await prefs.setStringList(key, cartItems);
  }

  static Future<void> datHang({
    required String customerName,
    required String email,
    required String tel,
  }) async {
    final url = Uri.parse('$baseUrl/cart/save.asp');

    final response = await http.post(url, body: {
      'CustomerName': customerName,
      'EmailAddress': email,
      'Tel': tel
    });

    if (response.statusCode == 200) {
      print('Đặt hàng thành công: ${response.body}');
    } else {
      print('Lỗi khi đặt hàng: ${response.statusCode}');
      throw Exception('Đặt hàng thất bại');
    }
  }

  static Future<void> saveOrderHistory(
      String userId, List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'order_history_$userId';
    final existingHistory = prefs.getStringList(key) ?? [];
    for (var item in items) {
      existingHistory.add(jsonEncode(item.toJson()));
    }
    await prefs.setStringList(key, existingHistory);
  }

  static Future<void> clearOrderHistory(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'order_history_$userId';
    await prefs.remove(key);
  }

  static Future<bool> toggleFavourite({
    required BuildContext context,
    required String userId,
    required int productId,
    required String tieude,
    required String gia,
    required String hinhdaidien,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favourite_items_$userId';
    List<String> favouriteItems = prefs.getStringList(key) ?? [];

    final itemMap = {
      'id': productId.toString(),
      'tieude': tieude,
      'gia': gia,
      'hinhdaidien': hinhdaidien,
    };

    bool exists = false;
    String? existingItem;

    for (var itemStr in favouriteItems) {
      try {
        final item = json.decode(itemStr);
        if (item['id'] == productId.toString()) {
          exists = true;
          existingItem = itemStr;
          break;
        }
      } catch (_) {}
    }

    if (exists && existingItem != null) {
      favouriteItems.remove(existingItem);
      await prefs.setStringList(key, favouriteItems);
      showNotification(context, 'Đã xóa khỏi yêu thích', Colors.green);
      print('❌ Đã xóa khỏi yêu thích: $productId');
      return false; // Trả về false để biết là đã xóa
    } else {
      favouriteItems.add(json.encode(itemMap));
      await prefs.setStringList(key, favouriteItems);
      showNotification(context, 'Đã thêm vào yêu thích', Colors.green);
      print('❤️ Đã thêm vào yêu thích: $productId');
      return true; // Trả về true để biết là đã thêm
    }
  }

  static Future<List<dynamic>> fetchBoLoc() async {
    final url = Uri.parse('$baseUrl/ww2/crm.boloc.master.asp');
    print('urlboloc: $url');

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data : [data];
    } else {
      throw Exception('Lỗi khi lấy bộ lọc: ${response.statusCode}');
    }
  }

  static Future<List<dynamic>> fetchBoLocChiTiet(String id) async {
    final url = Uri.parse('$baseUrl/ww2/crm.boloc.chitiet.asp?id=$id');

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is List ? data : [data];
    } else {
      throw Exception('Lỗi khi lấy bộ lọc chi tiết: ${response.statusCode}');
    }
  }
}
