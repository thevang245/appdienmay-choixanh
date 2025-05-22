import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
      items: const [
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
          icon: ImageIcon(
            AssetImage('asset/shopping-cart.png'),
            size: 24,
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
