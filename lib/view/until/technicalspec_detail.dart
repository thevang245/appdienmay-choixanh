import 'package:flutter/material.dart';

class TechnicalSpecs extends StatelessWidget {
  final Map<String, String> specs;

  const TechnicalSpecs({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    // Lọc các thông số không rỗng
    final validSpecs = specs.entries.where((e) => e.value.isNotEmpty).toList();

    // Nếu không có thông số nào hợp lệ thì không hiển thị gì
    if (validSpecs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10,),
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 6,left: 8
      ),
      color: Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông số kỹ thuật',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List<TableRow>.generate(
              validSpecs.length,
              (index) {
                final e = validSpecs[index];
                final isEven = index % 2 == 0;
                return TableRow(
                  decoration: BoxDecoration(
                    color: isEven ? Colors.white : Colors.grey[50],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '${e.key}:',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        e.value,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
