import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/view/allpage.dart';
import 'package:flutter_application_1/view/auth/auth_service.dart';
import 'package:flutter_application_1/view/auth/register.dart';
import 'package:flutter_application_1/widgets/button_widget.dart';
import 'package:flutter_application_1/widgets/input_widget.dart';
import 'package:flutter_application_1/widgets/label_widget.dart';
import 'package:flutter_application_1/widgets/widget_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
   @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
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
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start, // label sát trái
                children: [
                  Center(
                      child: appLogo),
                  FormLabel('Số điện thoại/Email'),
                  const SizedBox(height: 6),
                  CustomTextField(
                    label: 'Nhập số điện thoại hoặc email',
                    icon: Icons.person,
                    controller: _username,
                    maxline: 1,
                  ),
                  const SizedBox(height: 10),
                  FormLabel('Mật khẩu'),
                  const SizedBox(height: 6),
                  CustomTextField(
                    maxline: 1,
                    label: 'Nhập mật khẩu',
                    icon: Icons.key,
                    isPassword: true,
                    controller: _password,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: CustomButton(
                      onPressed: () async {
                        final login = await AuthService.handleLogin(context, _username.text.trim(), _password.text.trim());
                      },
                      text: 'Đăng nhập',
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  textSwitchPage(
                      firstText: 'Bạn chưa có tài khoản',
                      actionText: 'Đăng ký',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  Center(child: textLoginWith()),
                  buildSocialIconButton(
                      'asset/google.png', 'Đăng nhập với Google', () {})
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
