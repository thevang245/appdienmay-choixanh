import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/button_widget.dart';
import 'package:flutter_application_1/widgets/input_widget.dart';

class SearchcreenPage extends StatelessWidget {
  const SearchcreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Page')),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Column(
          children: [
            CustomTextField(
              label: 'Họ tên',
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(label: 'Địa chỉ email'),
            SizedBox(
              height: 10,
            ),
            CustomTextField(label: 'Địa chỉ'),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(label: 'Điện thoại'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: CustomTextField(label: 'Mã xác nhận'),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              label: 'Nội dung',
              maxline: 3,
            ),
            SizedBox(
              height: 30,
            ),
            CustomButton(text: 'Gửi đi', onPressed: () {})
          ],
        ),
      ),
    );
  }
}
