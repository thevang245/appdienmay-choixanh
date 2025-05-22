import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/auth/auth_service.dart';
import 'package:flutter_application_1/view/auth/login.dart';
import 'package:flutter_application_1/view/auth/register.dart';
import 'package:flutter_application_1/view/profile/profile_button.dart';
import 'package:flutter_application_1/widgets/card_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onTapCartHistory;
  const ProfilePage({super.key,required this.onTapCartHistory});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLogin = false;
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadLoginStatus();
  }

  // Hàm load trạng thái đăng nhập từ SharedPreferences
  Future<void> loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('isLoggedIn') ?? false;
    String user = prefs.getString('user') ?? '';

    setState(() {
      isLogin = status;
      userName = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(

        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              elevation: 0,
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Image.asset(
                      'asset/avatar.png',
                      width: 70,
                      height: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: isLogin
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Xin chào, $userName',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Bạn đã đăng nhập',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Vui lòng đăng nhập để mua hàng',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    buttonProfile(
                                        title: 'Đăng nhập',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Login(),
                                              )).then((_) {
                                            // Khi quay lại tự động reload lại trạng thái
                                            loadLoginStatus();
                                          });
                                        }),
                                    SizedBox(width: 8),
                                    buttonProfile(
                                        backgroundColor: Colors.black12,
                                        title: 'Đăng ký',
                                        textColor: Colors.black,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Register()));
                                        }),
                                  ],
                                ),
                              ],
                            ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            SettingItemCard(
             onTap: widget.onTapCartHistory,
              icon: Icons.work_history_outlined,
              title: 'Lịch sử mua hàng',
              iconRight: Icons.chevron_right,
            ),
            SettingItemCard(
              icon: Icons.cabin,
              title: 'Giới thiệu về Chồi Xanh Media',
              iconRight: Icons.chevron_right,
            ),
            SettingItemCard(
                icon: Icons.verified_user_rounded,
                title: 'Chính sách bảo mật',
                iconRight: Icons.chevron_right),
            SettingItemCard(
                icon: Icons.share,
                title: 'Chia sẻ ứng dụng',
                iconRight: Icons.chevron_right),
            SettingItemCard(
                icon: Icons.update,
                title: 'Phiên bản 1.1.1',
                iconRight: Icons.chevron_right),
            SizedBox(
              height: 10,
            ),
            SettingItemCard(
              icon: Icons.logout_rounded,
              title: 'Đăng xuất',
              onTap: () async {
                final authService = await AuthService.handleLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
