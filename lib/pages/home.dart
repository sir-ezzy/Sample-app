// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/item_controller.dart';
import '../widgets/item_tile.dart';
import '../widgets/add_edit_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: controller.toggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.item.isEmpty) {
          return const Center(child: Text('No items yet. Add one!'));
        }
        return ListView.builder(
          itemCount: controller.item.length,
          padding: EdgeInsets.symmetric(horizontal: 5),
          itemBuilder: (context, index) {
            final item = controller.item[index];
            return Card(
              child: ItemTile(
                item: item,
                onTap: () => Get.dialog(AddEditDialog(item: item)),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.dialog(const AddEditDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
