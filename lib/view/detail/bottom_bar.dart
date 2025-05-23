import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class BottomActionBar extends StatelessWidget {
  final int productId;
  final String userId;
  final String passwordHash;
  final String tieude;
  final String gia;
  final String hinhdaidien;
  final ValueNotifier<int> cartitemCount;

  const BottomActionBar(
      {super.key,
      required this.productId,
      required this.userId,
      required this.passwordHash,
      required this.tieude,
      required this.gia,
      required this.hinhdaidien,
      required this.cartitemCount});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 55,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff0066FF), // Màu viền dưới
                      width: 12, // Độ dày viền
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    await APIService.addToCart(
                        userId: userId,
                        passwordHash: passwordHash,
                        productId: productId,
                        tieude: tieude,
                        gia: gia,
                        hinhdaidien: 'https://choixanh.com.vn$hinhdaidien',
                        cartitemCount: cartitemCount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xff0066FF),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shopping_cart,
                          size: 20, color: Color(0xff0066FF)),
                      SizedBox(height: 2),
                      Text(
                        'Thêm vào giỏ hàng',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff0066FF)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 8,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0066FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: const Center(
                    child: Text('Mua ngay',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
