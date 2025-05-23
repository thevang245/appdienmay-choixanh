import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/services/api_service.dart';

class ItemCart extends StatelessWidget {
  final bool isSelected;
  final CartItemModel item;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onSelectedChanged;
  final ValueNotifier<int> cartitemCount;

  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? OnDeleted;

  final String userId;

  const ItemCart(
      {super.key,
      required this.isSelected,
      required this.item,
      this.onTap,
      this.onSelectedChanged,
      required this.cartitemCount,
      this.onIncrease,
      this.onDecrease,
      required this.userId,
      this.OnDeleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: onSelectedChanged,
                    activeColor: const Color(0xff0066FF),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: onTap,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name ?? 'Không có tên',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${item.price.toStringAsFixed(0)}₫',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onDecrease,
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: onIncrease,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await APIService.removeCartItem(
                          cartitemCount: cartitemCount,
                            userId: userId, productId: '${item.id}');
                        if (OnDeleted != null) OnDeleted!();
                      },
                      child: Text('Xóa sản phẩm'),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
