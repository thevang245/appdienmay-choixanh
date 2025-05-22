import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widget_auth.dart';

class DanhMucDrawer extends StatelessWidget {
  final void Function(int) onCategorySelected;

  DanhMucDrawer({required this.onCategorySelected});

  List<int> extractDanhMucChaIds(Map<String, dynamic> data) {
    List<int> ids = [];

    data.forEach((key, value) {
      if (value is int && value > 0) {
        ids.add(value);
      } else if (value is Map && value['id'] is int) {
        ids.add(value['id']);
      }
    });

    return ids;
  }

  String findCategoryNameById(Map<String, dynamic> data, int id) {
    for (var entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is int) {
        if (value == id) {
          return key;
        }
      } else if (value is Map) {
        if (value['id'] == id) {
          return key;
        }
        if (value.containsKey('children')) {
          final nameInChildren = findCategoryNameById(value['children'], id);
          if (nameInChildren.isNotEmpty) return nameInChildren;
        }
      }
    }
    return '';
  }

  final Map<String, dynamic> danhMucData = {
    'Trang chủ': 0,
    'Máy vi tính': 35279,
    'Điện thoại di động': 35278,
    'Tivi': 35280,
    'Máy lạnh': 35283,
    'Tuyển nhân sự': 35004,
    'Công nghệ': {
      'id': 35139,
      'children': {
        'AI': null,
        'Chuyển đổi số': null,
        'Nhịp sống số': null,
        'Thiết bị': null,
        'Trải nghiệm': null
      }
    },
    'Cười': {
      'id': 35149,
      'children': {
        'Tiểu phẩm': 35251,
        'Thư giản': 35252,
      },
    },
    'Liên hệ': 35028,
  };

  @override
  Widget build(BuildContext context) {
    final double appBarHeight =
        kToolbarHeight + MediaQuery.of(context).padding.top;

    return Drawer(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: appBarHeight,
              width: double.infinity,
              color: Color(0xFF198754),
              child: Stack(
                children: [
                  Center(
                    child: Image.network(
                      'https://choixanh.vn/mediaroot/media/userfiles/useruploads/1/image/he-thong/logo-10.png',
                      color: Colors.white,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Đóng Drawer
                      },
                      child: Row(
                        children: [
                          Icon(Icons.close, color: Colors.white70, size: 18),
                          SizedBox(width: 2),
                          Text(
                            'Đóng',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  ...danhMucData.entries.map((entry) {
                    final value = entry.value;
                    // Trường hợp mục chính là int (có id)
                    if (value == null || value is int) {
                      return ListTile(
                        title: Text(entry.key),
                        onTap: () {
                          if (value != null) {
                            onCategorySelected(value);
                          }
                          Navigator.of(context).pop();
                        },
                      );
                    }

                    // Trường hợp có children (như "Cười")
                    else if (value is Map<String, dynamic>) {
                      final parentId = value['id'];
                      final children =
                          value['children'] as Map<String, dynamic>?;

                      return ExpansionTile(
                        title: InkWell(
                          onTap: () {
                            if (parentId != null) {
                              onCategorySelected(parentId);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(entry.key,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        children: children?.entries.map((subEntry) {
                              final subId = subEntry.value;
                              return ListTile(
                                title: Text(subEntry.key),
                                onTap: () {
                                  if (subId != null) {
                                    onCategorySelected(subId);
                                  }
                                  Navigator.of(context).pop();
                                },
                              );
                            }).toList() ??
                            [],
                      );
                    }

                    return SizedBox.shrink();
                  }).toList(),
                  const SizedBox(height: 24),
                  Divider(
                    thickness: 1,
                    color: Color(0xFF0033FF),
                  ),
                  const SizedBox(height: 12),
                  Text(
                      'Chồi Xanh Media cung cấp các loại máy tính, laptop và thiết bị công nghệ chất lượng cao, đáp ứng mọi nhu cầu của doanh nghiệp và cá nhân'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.home_work_sharp),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Công ty chồi xanh Media',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 8),
                      Text('82A - 82B Dân Tộc, Q. Tân Phú'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.document_scanner),
                      SizedBox(width: 8),
                      Text('MST: 0314581926'),
                    ],
                  ),
                  Text('028 3974 3179'),
                  Text('info@choixanh.vn'),
                  Row(
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 8),
                      Text('Theo dõi Chồi Xanh Media'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
