import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class BoLocDrawer extends StatefulWidget {
  @override
  _BoLocDrawerState createState() => _BoLocDrawerState();
}

class _BoLocDrawerState extends State<BoLocDrawer> {
  List<Map<String, dynamic>> filtersWithChildren = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBoLocIncrementally();
  }

  Future<void> _fetchBoLocIncrementally() async {
    final filters = await APIService.fetchBoLoc();

    for (var filter in filters) {
      final id = filter['id'];
      final childrenRaw = await APIService.fetchBoLocChiTiet(id);
      final children =
          (childrenRaw.isNotEmpty && childrenRaw[0]['thamso'] != null)
              ? childrenRaw[0]['thamso']
              : [];

      if (children.isNotEmpty) {
        filter['children'] = children;
        setState(() {
          filtersWithChildren.add(filter);
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight =
        kToolbarHeight + MediaQuery.of(context).padding.top;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: appBarHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF198754), Color(0xFF198754)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Bộ lọc",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.close, color: Colors.white, size: 20),
                      SizedBox(width: 2),
                      Text(
                        "Đóng",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading && filtersWithChildren.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: filtersWithChildren.length,
                    itemBuilder: (context, index) {
                      final filter = filtersWithChildren[index];
                      final title = filter['tieude'] ?? 'Bộ lọc $index';
                      final children = filter['children'] ?? [];

                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                            16, index == 0 ? 0 : 10, 16, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: children.map<Widget>((child) {
                                final childTitle =
                                    child['tengoi'] ?? 'Chi tiết';
                                return FilterChip(
                                  label: Text(childTitle),
                                  backgroundColor: Colors.grey[100],
                                  side: BorderSide.none,
                                  onSelected: (bool selected) {
                                    Navigator.of(context).pop();
                                    // TODO: xử lý chọn chip con
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
