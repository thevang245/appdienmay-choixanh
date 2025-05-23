import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartitemCount;
  

  const CustomBottomNavBar(
      {super.key,
      required this.currentIndex,
      required this.onTap,
      required this.cartitemCount});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor:
          Colors.transparent, // làm nền trong suốt để thấy gradient
      elevation: 0, // bỏ shadow
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xff0066FFF),
      unselectedItemColor: Colors.black54,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('asset/home.png'),
            size: 24,
          ),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('asset/favourite.png'),
            size: 24,
          ),
          label: 'Yêu thích',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior:
                Clip.none, // Cho phép phần tử Positioned tràn ra ngoài
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: const ImageIcon(
                  AssetImage('asset/shopping-cart.png'),
                  size: 24,
                ),
              ),
              if (cartitemCount > 0)
                Positioned(
                  right: -8, // đẩy ra sát góc
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartitemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Giỏ hàng',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('asset/user.png'),
            size: 24,
          ),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
