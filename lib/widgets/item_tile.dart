// lib/widgets/item_tile.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/model/items.dart';
import '../controllers/item_controller.dart';

class ItemTile extends StatelessWidget {
  final Items item;
  final VoidCallback onTap;

  const ItemTile({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ItemController>();

    return Dismissible(
      key: ValueKey(item.key),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteItem(item),
      child: ListTile(
        title: Text(item.title),
        subtitle: item.description != null ? Text(item.description!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
