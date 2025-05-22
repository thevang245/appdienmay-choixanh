import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/view/auth/login.dart';
import 'package:flutter_application_1/widgets/button_widget.dart';
import 'package:flutter_application_1/widgets/input_widget.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';
import 'package:flutter_application_1/widgets/widget_auth.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<bool> registerUser({
    required String id2,
    required String loaithanhvien,
    required String tenkh,
    required String email,
    required String tel,
    required String userid,
    required String pass,
  }) async {
    try {
      final Uri url = Uri.parse(
          '${APIService.loginUrl}?id2=$id2&loaithanhvien=$loaithanhvien&tenkh=${Uri.encodeComponent(tenkh)}&email=$email&tel=$tel&userid=$userid&pass=$pass');

      var response = await http.post(url);

      print('Request URL: $url');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final body = response.body.trim();

        try {
          final List<dynamic> data = jsonDecode(body);

          if (data.isNotEmpty) {
            final thongBao = data[0]['ThongBao'] ?? '';
            final maLoi = data[0]['maloi'] ?? '0';

            if (maLoi == '1') {
              print('Đăng ký thành công: $thongBao');
              return true;
            } else {
              print('Đăng ký thành công, mật khẩu sẽ được gửi qua email');
              return false;
            }
          } else {
            print('Phản hồi rỗng');
            return false;
          }
        } catch (e) {
          print('Lỗi parse JSON: $e');
          return false;
        }
      } else {
        print('Lỗi kết nối server: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Lỗi: $e');
      return false;
    }
  }

  void handleRegister() async {
    String fullname = _fullnameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        fullname.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }


    bool isSuccess = await registerUser(
      id2: 'Chophepdangky', // hoặc giá trị cố định theo backend yêu cầu
      loaithanhvien: '1', // hoặc giá trị mặc định bạn muốn
      tenkh: username,
      email: email,
      tel: phone,
      userid: username,
      pass: password,
    );

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thành công')),
      );
      // Ví dụ chuyển sang màn hình login sau đăng ký thành công
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackground,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: appLogo),
                    FormLabel('Họ và tên'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      label: 'Nhập họ và tên',
                      icon: Icons.person,
                      controller: _fullnameController,
                      maxline: 1,
                    ),
                    const SizedBox(height: 10),
                    FormLabel('Email'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      label: 'Nhập email',
                      icon: Icons.email,
                      controller: _emailController,
                      maxline: 1,
                    ),
                    const SizedBox(height: 10),
                    FormLabel('Số điện thoại'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      label: 'Nhập số điện thoại',
                      icon: Icons.phone,
                      controller: _phoneController,
                      maxline: 1,
                    ),
                    const SizedBox(height: 10),
                    FormLabel('Username'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      label: 'Nhập username',
                      icon: Icons.key,
                      controller: _usernameController,
                      maxline: 1,
                      isPassword: true,
                    ),
                    const SizedBox(height: 10),
                    FormLabel('Mật khẩu'),
                    const SizedBox(height: 6),
                    CustomTextField(
                      label: 'Nhập lại mật khẩu',
                      icon: Icons.key,
                      controller: _passwordController,
                      maxline: 1,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: CustomButton(
                        onPressed: () {
                          handleRegister();
                        },
                        text: 'Đăng ký',
                        textColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    textSwitchPage(
                      firstText: 'Bạn đã có tài khoản',
                      actionText: 'Đăng nhập',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
