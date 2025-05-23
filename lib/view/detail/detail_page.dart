import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/models/category_model.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/view/auth/register.dart';
import 'package:flutter_application_1/view/cart/cart_page.dart';
import 'package:flutter_application_1/view/components/bottom_appbar.dart';
import 'package:flutter_application_1/view/detail/comment_card.dart';
import 'package:flutter_application_1/view/detail/bottom_bar.dart';
import 'package:flutter_application_1/view/detail/detail_description.dart';
import 'package:flutter_application_1/view/detail/detail_imggallery.dart';
import 'package:flutter_application_1/view/detail/detail_pricetitle.dart';
import 'package:flutter_application_1/view/detail/relatedproduct_card.dart';
import 'package:flutter_application_1/view/detail/specs_data.dart';
import 'package:flutter_application_1/view/home/homepage.dart';
import 'package:flutter_application_1/view/profile/profile.dart';
import 'package:flutter_application_1/view/until/technicalspec_detail.dart';
import 'package:flutter_application_1/view/until/until.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart'; // Dùng để parse chuỗi HTML

class DetailPage extends StatefulWidget {
  final String productId;
  final ValueNotifier<int> categoryNotifier;
  final ValueNotifier<int> cartitemCount;
  final VoidCallback? onBack;
  final void Function(dynamic product)? onProductTap;

  const DetailPage(
      {super.key,
      required this.productId,
      required this.categoryNotifier,
      required this.cartitemCount,
      this.onBack,
      this.onProductTap});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? selectedImageUrl;
  String? htmlContent;
  bool isLoadingHtml = true;
  bool isExpanded = false;
  Map<String, dynamic>? productDetail;
  bool isLoading = true;
  bool isBackVisible = true;
  final ScrollController _scrollController = ScrollController();
  List<dynamic> commentCard = [];
  late String moduleType;
  List<dynamic> _productsRelated = [];

  String getModuleNameFromCategoryId(int categoryId) {
    if (categoryModules.containsKey(categoryId)) {
      final moduleParts = categoryModules[categoryId];
      if (moduleParts != null && moduleParts.length >= 3) {
        return moduleParts[1];
      } else {
        print('=> Không đủ phần tử hoặc null');
      }
    } else {
      print('=> Không tìm thấy categoryId trong map');
    }
    return 'sanpham';
  }

  Future<void> loadProductDetail() async {
    final detail = await APIService.fetchProductDetail(
      APIService.baseUrl,
      moduleType,
      widget.productId,
      getDanhSachHinh,
    );
    if (detail != null) {
      final hinhAnhs = getDanhSachHinh(detail);
      setState(() {
        productDetail = detail;
        isLoading = false;
        selectedImageUrl = hinhAnhs.isNotEmpty ? hinhAnhs[0] : null;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadHtmlContent(String url) async {
    setState(() {
      isLoadingHtml = true;
    });
    final content = await APIService.fetchHtmlContent(url);
    setState(() {
      htmlContent = content;
      isLoadingHtml = false;
    });
  }

  @override
  void initState() {
    super.initState();

    moduleType = getModuleNameFromCategoryId(widget.categoryNotifier.value);

    getProducts();

    final htmlUrl =
        'https://choixanh.com.vn/ww2/module.$moduleType.chitiet.asp?id=${widget.productId}&sl=30&pageid=1';
    loadHtmlContent(htmlUrl);

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isBackVisible) setState(() => isBackVisible = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isBackVisible) setState(() => isBackVisible = true);
      }
    });

    loadProductDetail();
    loadComments();
  }

  Future<void> loadComments() async {
    try {
      final response = await APIService.loadComments();
      if (mounted) {
        setState(() {
          commentCard = response;
        });
      }
      print('Số comment sau khi load: ${commentCard.length}');
    } catch (e) {
      print('Lỗi khi load comment: $e');
    }
  }

  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? '';
    return parsedString.trim();
  }

  void getProducts() async {
    List<dynamic> products =
        await APIService.getProductRelated(id: widget.productId);

    setState(() {
      _productsRelated = products;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Đang tải...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final product = productDetail ?? {};
    final hinhAnhs = getDanhSachHinh(product);
    final String title = product['tieude'] ?? 'Sản phẩm chưa có tên';
    final String price = product['gia'] ?? 'Chưa có giá';
    final String description = (product['noidungchitiet'] ?? 'Không có mô tả')
        .replaceAll("''", '"'); // Chuyển '' => "

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 55, top: 0),
            child: NotificationListener<ScrollNotification>(
              onNotification: (_) => true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60), // để trống phần appbar
                    if (hinhAnhs.isNotEmpty)
                      DetailImageGallery(
                        images: hinhAnhs,
                        onImageSelected: (url) {
                          setState(() => selectedImageUrl = url);
                        },
                      ),
                    const SizedBox(height: 16),
                    DetailPriceTitle(product: product),
                    DetailHtmlContent(
                      htmlContent: description,
                      isLoading: isLoadingHtml,
                      isExpanded: isExpanded,
                      onToggle: () => setState(() => isExpanded = !isExpanded),
                    ),
                    const SizedBox(height: 8),
                    TechnicalSpecs(
                      specs: {
                        for (var entry in productSpecsMapping)
                          entry.key: getNestedTengoi(product, entry.value)
                      },
                    ),
                    if (_productsRelated.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50], // Nền xám nhạt
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: Text(
                                'Sản phẩm liên quan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 220, // Chiều cao đủ để hiển thị sản phẩm
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _productsRelated.length,
                                itemBuilder: (context, index) {
                                  final item = _productsRelated[index];
                                  return RelatedProductCard(
                                    product: item,
                                    onTap: () {
                                      if (widget.onProductTap != null) {
                                        widget.onProductTap!(item);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (commentCard.isNotEmpty) ...[
                      Container(
                        color: Colors.grey[50], // màu nền xám nhạt
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Khách hàng nhận xét',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: commentCard.length,
                                itemBuilder: (context, index) {
                                  final comment = commentCard[index];
                                  return CommentCard(
                                    name: comment['tieude'] ?? 'Ẩn danh',
                                    content: parseHtmlString(
                                        comment['noidungtomtat'] ?? ''),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isBackVisible ? 1.0 : 0.0,
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.black.withOpacity(0.5)),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (widget.onBack != null) {
                            widget.onBack!();
                          }
                        },
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          color: Colors.black.withOpacity(0.5)),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.white),
                        onPressed: () async {
                          await APIService.toggleFavourite(
                              context: context,
                              userId: Global.userId,
                              productId: int.tryParse(widget.productId) ?? 0,
                              tieude: product['tieude'],
                              gia: product['gia'],
                              hinhdaidien:
                                  'https://choixanh.com.vn/${product['hinhdaidien']}');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom bar
          if ((productDetail?['gia'] ?? '').toString().trim().isNotEmpty &&
              hinhAnhs.isNotEmpty)
            BottomActionBar(
              tieude: product['tieude'],
              gia: product['gia'],
              hinhdaidien: product['hinhdaidien'],
              productId: int.tryParse(widget.productId) ?? 0,
              userId: Global.userId,
              passwordHash: Global.pass,
              cartitemCount: widget.cartitemCount,
            )
        ],
      ),
    );
  }
}
