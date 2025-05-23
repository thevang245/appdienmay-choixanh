import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class BoLocDrawer extends StatefulWidget {
  @override
  _BoLocDrawerState createState() => _BoLocDrawerState();
}

class _BoLocDrawerState extends State<BoLocDrawer> {
  late Future<List<dynamic>> futureBoLocFiltered;

  @override
  void initState() {
    super.initState();
    futureBoLocFiltered = _fetchBoLocWithChildren();
  }

  Future<List<dynamic>> _fetchBoLocWithChildren() async {
    final filters = await APIService.fetchBoLoc();
    List<dynamic> result = [];

    for (var filter in filters) {
      final id = filter['id'];
      final childrenRaw = await APIService.fetchBoLocChiTiet(id);
      final children =
          (childrenRaw.isNotEmpty && childrenRaw[0]['thamso'] != null)
              ? childrenRaw[0]['thamso']
              : [];

      if (children.isNotEmpty) {
        filter['children'] = children;
        result.add(filter);
      }
    }

    return result;
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
            child: FutureBuilder<List<dynamic>>(
              future: futureBoLocFiltered,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có dữ liệu bộ lọc'));
                } else {
                  final filters = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
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
                                  side: BorderSide.none, // Không viền
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
