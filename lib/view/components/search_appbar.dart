import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/search/search_page.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       // Color(0xFF0033FF), // Blue đậm
        //       // Colors.lightBlueAccent,
        //       Color(0xFF17865B),
        //       Color(0xFF17865B)
        //     ],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        child: AppBar(
          backgroundColor: Color(0xFF198754), // Rất quan trọng!
          elevation: 0,
          leading: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, top: 12, bottom: 12, right: 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
          ),
          title: Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchcreenPage()));
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
