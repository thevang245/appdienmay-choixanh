import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/button_widget.dart';
import 'package:flutter_application_1/widgets/input_widget.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.037;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.apartment, 'Công ty TNHH Chồi Xanh Media',
                    '', fontSize),
                SizedBox(height: 8),
                _buildInfoRow(
                    Icons.location_on,
                    '82A-82B Dân Tộc, Quận Tân Phú, TP. Hồ Chí Minh',
                    '',
                    fontSize),
                SizedBox(height: 8),
                _buildInfoRow(
                    Icons.phone, 'Điện thoại:', '028 3974 3179', fontSize),
                SizedBox(height: 8),
                _buildInfoRow(
                    Icons.email, 'Email:', 'info@Tuyennhansu.com', fontSize),
                SizedBox(height: 8),
                _buildInfoRow(
                    Icons.language, 'Website:', 'TuyenNhanSu.com', fontSize),
                SizedBox(height: 20),
                const CustomTextField(label: 'Họ tên'),
                SizedBox(height: 10),
                const CustomTextField(label: 'Địa chỉ email'),
                SizedBox(height: 10),
                const CustomTextField(label: 'Địa chỉ'),
                SizedBox(height: 10),
                Row(
                  children: const [
                    Expanded(
                      flex: 3,
                      child: CustomTextField(label: 'Điện thoại'),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: CustomTextField(label: 'Mã xác nhận'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                const CustomTextField(label: 'Nội dung', maxline: 3),
                SizedBox(height: 30),
                CustomButton(
                  text: 'Gửi đi',
                  onPressed: () {
                    // Xử lý gửi thông tin ở đây
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String textStart, String? textEnd, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: fontSize + 4),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: textStart,
              style: TextStyle(fontSize: fontSize, color: Colors.black),
              children: [
                if (textEnd != null && textEnd.isNotEmpty)
                  TextSpan(
                    text: " $textEnd",
                    style: TextStyle(fontSize: fontSize, color: Colors.blue),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
