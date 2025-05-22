import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final int? maxline;

  const CustomTextField(
      {Key? key,
      required this.label,
      this.icon,
      this.isPassword = false,
      this.controller,
      this.maxline})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
     final widthScreen = MediaQuery.of(context).size.width;
     double fontSize = widthScreen * 0.036;
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Color(0xFFECF1FF), // Nền trắng
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLines: widget.maxline,
        obscureText: widget.isPassword ? _obscureText : false,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.label,
          hintStyle: TextStyle(color: Colors.black54, fontSize: fontSize),
          labelStyle: const TextStyle(color: Colors.black54),
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: Colors.black54)
              : null,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue, width: 3),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        style: const TextStyle(color: Colors.black87),
        cursorColor: Colors.blue,
      ),
    );
  }
}
