import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String name;
  final String content;

  const CommentCard({
    super.key,
    required this.name,
    required this.content,
  });

  void _showFullComment(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: Text(name, style: TextStyle(color: Color(0xff0066FF))),
        content: SingleChildScrollView(
          child: Text(content, style: TextStyle(fontSize: 16)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Đóng", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxLength = 160;
    final isLong = content.length > maxLength;
    final shortContent = isLong ? content.substring(0, maxLength) : content;

    return InkWell(
      onTap: isLong ? () => _showFullComment(context) : null,
      child: Container(
        width: 280,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xff0066FF),
              ),
            ),
            SizedBox(height: 8),
            isLong
                ? RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(text: "$shortContent... "),
                        TextSpan(
                          text: "Xem thêm",
                          style: TextStyle(
                            color: Colors.grey[500],
                            
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(content, style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
