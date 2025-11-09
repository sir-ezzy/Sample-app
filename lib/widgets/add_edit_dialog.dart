// lib/widgets/add_edit_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/items.dart';
import '../controllers/item_controller.dart';

class AddEditDialog extends StatefulWidget {
  final Items? item;

  const AddEditDialog({super.key, this.item});

  @override
  State<AddEditDialog> createState() => _AddEditDialogState();
}

class _AddEditDialogState extends State<AddEditDialog> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.item?.title ?? '');
    _descCtrl = TextEditingController(text: widget.item?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ItemController>();
    final isEdit = widget.item != null;

    return AlertDialog(
      title: Text(isEdit ? 'Edit Item' : 'Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _descCtrl,
            decoration: const InputDecoration(
              labelText: 'Description (optional)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final title = _titleCtrl.text.trim();
            if (title.isEmpty) return;

            if (isEdit) {
              controller.updateItem(
                widget.item!,
                title,
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
              );
            } else {
              controller.addItem(
                title,
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
              );
            }
            Get.back();
          },
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
