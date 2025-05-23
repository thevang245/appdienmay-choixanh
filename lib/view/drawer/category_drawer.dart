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
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_double_arrow_left,
                              color: Colors.white70, size: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[100],
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
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Chồi Xanh Media ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF198754),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'cung cấp các loại máy tính, laptop và thiết bị công nghệ chất lượng cao, đáp ứng mọi nhu cầu của doanh nghiệp và cá nhân.',
                                  style: TextStyle(
                                    fontSize: 15.5,
                                    height: 1.3,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                            icon: Icons.apartment,
                            text: 'Công ty Chồi Xanh Media'),
                        const SizedBox(height: 12),
                        _InfoRow(
                            icon: Icons.location_on,
                            text: '82A - 82B Dân Tộc, Q. Tân Phú'),
                        const SizedBox(height: 12),
                        _InfoRow(
                            icon: Icons.document_scanner,
                            text: 'MST: 0314581926'),
                        const SizedBox(height: 12),
                        _InfoRow(icon: Icons.phone, text: '028 3974 3179'),
                        const SizedBox(height: 12),
                        _InfoRow(icon: Icons.email, text: 'info@choixanh.vn'),
                        const SizedBox(height: 12),
                        _InfoRow(
                            icon: Icons.share,
                            text: 'Theo dõi Chồi Xanh Media'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 20,
            color: Color(0xFF198754),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
