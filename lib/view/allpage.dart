import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/view/auth/login.dart';
import 'package:flutter_application_1/view/auth/register.dart';
import 'package:flutter_application_1/view/cart/cart_history.dart';
import 'package:flutter_application_1/view/cart/cart_page.dart';
import 'package:flutter_application_1/view/components/bottom_appbar.dart';
import 'package:flutter_application_1/view/components/search_appbar.dart';
import 'package:flutter_application_1/view/detail/detail_page.dart';

import 'package:flutter_application_1/view/drawer/category_drawer.dart';
import 'package:flutter_application_1/view/drawer/filter_drawer.dart';
import 'package:flutter_application_1/view/favourite/favourite_page.dart';
import 'package:flutter_application_1/view/home/homepage.dart';
import 'package:flutter_application_1/view/profile/profile.dart';

class PageAll extends StatefulWidget {
  const PageAll({super.key});

  @override
  State<PageAll> createState() => _PageAllState();
}

class _PageAllState extends State<PageAll> {
  int _currentIndex = 0;
  final ValueNotifier<int> categoryNotifier = ValueNotifier(35278);
  final GlobalKey<favouritePageState> favouritePageKey =
      GlobalKey<favouritePageState>();
  final GlobalKey<PageCartState> cartPageKey = GlobalKey<PageCartState>();
  final GlobalKey<CarthistoryPageState> carthistoryPageKey =
      GlobalKey<CarthistoryPageState>();

  String _currentPage = 'home';
  String _previousPage = 'home';

  dynamic selectedProduct;

  late final HomePage _homePage;
  late final PageCart _cartPage;
  late final favouritePage _favouritePage;
  late final Register _registerPage;
  late final ProfilePage _profilePage;

  DetailPage? _detailPage;
  CarthistoryPage? _carthistoryPage;

  @override
  void initState() {
    super.initState();

    _homePage = HomePage(
      categoryNotifier: categoryNotifier,
      onProductTap: (product) {
        _goToDetail(product, 'home');
      },
    );

    _cartPage = PageCart(
      key: cartPageKey,
      onProductTap: (product) {
        _goToDetail(product, 'cart');
      },
    );
    _favouritePage = favouritePage(
      key: favouritePageKey,
    );
    _registerPage = Register();
    _profilePage = ProfilePage(
      onTapCartHistory: _goToCartHistory,
    );

    _carthistoryPage = CarthistoryPage(
      key: carthistoryPageKey,
    );
  }

  void _goToCartHistory() {
    setState(() {
      _currentPage = 'carthistory';
      carthistoryPageKey.currentState?.loadOrderHistory();
    });
  }

  void _goToDetail(dynamic product, String fromPage) {
    setState(() {
      selectedProduct = product;
      _previousPage = fromPage;
      _currentPage = 'detail';

      // Tạo một lần, không tạo lại mỗi khi build
      String productId = '0';
      if (product is CartItemModel) {
        productId = product.id;
      } else if (product is Map) {
        productId = product['id'].toString();
      }

      _detailPage = DetailPage(
        productId: productId,
        categoryNotifier: categoryNotifier,
        onBack: () {
          setState(() {
            _currentPage = _previousPage;
            _detailPage = null; // reset lại detail khi quay về
          });
        },
      );
    });
  }

  int _getPageIndex() {
    switch (_currentPage) {
      case 'home':
        return 0;
      case 'cart':
        return 1;
      case 'favourite':
        return 2;
      case 'register':
        return 3;
      case 'profile':
        return 4;
      case 'detail':
        return 5;
      case 'carthistory':
        return 6;
      default:
        return 0;
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          _currentPage = 'home';
          break;
        case 1:
          _currentPage = 'favourite';
          favouritePageKey.currentState?.reloadFavourites();
          break;
        case 2:
          _currentPage = 'cart';
          cartPageKey.currentState?.loadCartItems();
          break;
        case 3:
          _currentPage = 'profile';
          break;
        case 4:
          _currentPage = 'carthistory';
          carthistoryPageKey.currentState?.loadOrderHistory();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: DanhMucDrawer(
          onCategorySelected: (int id) async {
            await Navigator.of(context).maybePop();
            setState(() {
              _currentPage = 'home';
              categoryNotifier.value = id;
            });
          },
        ),
        endDrawer: BoLocDrawer(),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: kToolbarHeight,
              bottom:kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom, ),
              child: IndexedStack(
                index: _getPageIndex(),
                children: [
                  _homePage,
                  _cartPage,
                  _favouritePage,
                  _registerPage,
                  _profilePage,
                  _detailPage ?? Container(), // tránh null & tránh render lại
                  _carthistoryPage ?? Container(),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SearchAppBar(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    
                  ),
                  child: CustomBottomNavBar(
                    currentIndex: _currentIndex,
                    onTap: _onTabTapped,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
