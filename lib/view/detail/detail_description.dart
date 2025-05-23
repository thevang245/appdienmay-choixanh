import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:url_launcher/url_launcher.dart';

class DetailHtmlContent extends StatelessWidget {
  final String? htmlContent;
  final bool isLoading;
  final bool isExpanded;
  final VoidCallback onToggle;

  const DetailHtmlContent({
    super.key,
    required this.htmlContent,
    required this.isLoading,
    required this.isExpanded,
    required this.onToggle,
  });

  /// An toàn hơn: nếu null hoặc lỗi sẽ trả về "Không có nội dung"
  String _safeShortenHtml(String? html, int maxLength) {
    print("===> HTML nội dung chi tiết:\n$htmlContent");

    if (html == null || html.trim().isEmpty) return "<p>Không có nội dung</p>";

    try {
      if (html.length <= maxLength) return html;

      // Cắt HTML trực tiếp nhưng không phá vỡ thẻ HTML
      final truncated = html.substring(0, maxLength);
      return "$truncated...";
    } catch (e) {
      return "<p>Lỗi khi rút gọn nội dung</p>";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final safeHtmlContent = htmlContent?.trim().isNotEmpty == true
        ? htmlContent!
        : "<p>Không có nội dung</p>";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Html(
            data: isExpanded
                ? safeHtmlContent
                : _safeShortenHtml(safeHtmlContent, 300),
            style: {
              "body": Style(
                fontSize: FontSize(15.0),
                color: Colors.black,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: onToggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isExpanded ? 'Thu gọn' : 'Xem thêm',
                  style:
                      const TextStyle(color: Color(0xff0066FF), fontSize: 15),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xff0066FF),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
