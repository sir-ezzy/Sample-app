import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:sample/model/items.dart';

class ItemController extends GetxController {
  late Box<Items> box;

  var item = <Items>[].obs;
  // var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      // Add this line to see exactly what's wrong
      print("Opening Hive box...");
      box = await Hive.openBox<Items>('item');
      print("Box opened successfully!");

      _loadItems();
      await _seedInitialDataIfNeeded();
    } catch (e, stackTrace) {
      print("HIVE ERROR: $e");
      print("STACKTRACE: $stackTrace");

      Get.snackbar(
        "Database Error",
        "Could not open database:\n$e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 8),
      );
    }
  }

  void _loadItems() {
    item.assignAll(box.values.toList());
  }

  Future<void> _seedInitialDataIfNeeded() async {
    if (box.isEmpty) {
      final sampleItems = _generateSampleTodos();
      await box.addAll(sampleItems);
      _loadItems();
    }
  }

  void loadItems() {
    item.assignAll(box.values.toList());
  }

  void seedInitialDataIfNeeded() async {
    if (box.isEmpty) {
      final sampleItems = _generateSampleTodos();
      await box.addAll(sampleItems);
      _loadItems();
    }
  }

  List<Items> _generateSampleTodos() {
    final baseTitles = [
      "Buy groceries",
      "Call mom",
      "Finish Flutter project",
      "Go for a run",
      "Read 30 pages",
      "Water the plants",
      "Schedule dentist appointment",
      "Clean desk",
      "Learn GetX state management",
      "Deploy app to production",
      "Write blog post about Hive",
      "Fix login bug",
      "Team standup at 10 AM",
      "Review PR #42",
      "Update resume",
      "Plan weekend hiking trip",
      "Backup photos to cloud",
      "Pay electricity bill",
      "Cook pasta for dinner",
      "Walk the dog",
      "Meditate for 10 minutes",
      "Practice guitar chords",
      "Send thank you email to client",
      "Organize closet",
      "Charge laptop and phone",
      "Take out trash",
      "Reply to Slack messages",
      "Take a 5-minute stretch break",
      "Drink 2 liters of water",
      "Plan tomorrow's tasks",
      "Call insurance company",
      "Submit expense report",
      "Update pub dependencies",
      "Test dark mode UI",
      "Refactor ItemController",
      "Push code to GitHub",
      "Eat healthy lunch",
      "Attend Flutter webinar",
      "Buy birthday gift for Sarah",
      "Return library book",
      "Wash the car",
      "Fix leaky kitchen faucet",
      "Evening yoga session",
      "Grocery shopping for the week",
      "Send meeting notes to team",
      "Update personal portfolio",
      "Listen to productivity podcast",
      "Take daily vitamins",
      "Go to bed by 11 PM",
      "Celebrate small wins",
    ];

    return List.generate(50, (index) {
      final title = baseTitles[index % baseTitles.length];
      final suffix = index >= baseTitles.length ? ' #${index + 1}' : '';

      final descriptions = [
        "Remember to buy milk, eggs, bread, and fruits.",
        "Wish her happy birthday and ask about weekend plans.",
        "Complete the CRUD app with Hive and GetX.",
        "Run 5 km in the park before breakfast.",
        "Continue reading 'Clean Code' by Robert C. Martin.",
        "Check all indoor plants and water if dry.",
        "Book appointment for teeth cleaning next month.",
        "Remove clutter and organize cables.",
        "Watch official GetX tutorial on YouTube.",
        "Deploy using Codemagic or GitHub Actions.",
        "Write about 'Local Persistence with Hive'.",
        "Users can't log in with Google — fix OAuth flow.",
        "Prepare updates and blockers for the team.",
        "Review John's pull request carefully.",
        "Add new Flutter project and update skills section.",
        "Book cabin in the mountains for 2 nights.",
        "Upload all photos from phone to Google Drive.",
        "Due by 15th — pay online to avoid late fee.",
        "Try new tomato basil pasta recipe tonight.",
        "Take Max for a 30-minute walk in the evening.",
        "Use Headspace app for guided session.",
        "Practice C major, G major and Am chords.",
        "Thank them for the quick turnaround time.",
        "Donate old clothes and rearrange shelves.",
        "Both devices below 20% — plug in now.",
        "Recycle paper and plastic separately.",
        "Answer urgent messages from @channel.",
        "Stand up and stretch every hour.",
        "Track water intake using reminder app.",
        "Use Todo app to plan next day.",
        "Call about car insurance renewal.",
        "Submit receipts from last business trip.",
        "Run 'flutter pub upgrade' in terminal.",
        "Ensure all text is readable in dark mode.",
        "Extract logic into services and repositories.",
        "Commit with meaningful message.",
        "Prepare salad with grilled chicken and avocado.",
        "Join at 3 PM — take notes.",
        "Order online — arrives by Friday.",
        "Overdue since last week — return today.",
        "Use soap and sponge — avoid scratches.",
        "Tighten pipe under the sink.",
        "Follow 20-minute YouTube yoga flow.",
        "Make shopping list first to save time.",
        "Email summary within 1 hour after meeting.",
        "Add new Todo app project with screenshot.",
        "Listen to 'The Tim Ferriss Show' episode.",
        "Take vitamin D and multivitamin with breakfast.",
        "Avoid screens 1 hour before bed.",
        "You completed 50 sample todos — great job!",
      ];

      final descIndex = index % descriptions.length;
      final description = descriptions[descIndex];

      return Items(title: '$title$suffix', description: description);
    });
  }

  Future<void> addItem(String title, [String? description]) async {
    final newItem = Items(title: title, description: description);
    await box.add(newItem);
    _loadItems();

    Get.snackbar(
      "Success",
      "Item added successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> updateItem(
    Items oldItem,
    String title, [
    String? description,
  ]) async {
    final updated = oldItem.copyWith(title: title, description: description);
    oldItem
      ..title = updated.title
      ..description = updated.description
      ..save();

    _loadItems();

    Get.snackbar(
      "Updated",
      "Item updated successfully",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Future<void> deleteItem(Items item) async {
    final deletedItem = Items(
      title: item.title,
      description: item.description,
    ); // copy for undo

    await item.delete();
    _loadItems();

    Get.snackbar(
      "Deleted",
      "Item removed",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      mainButton: TextButton(
        onPressed: () async {
          await box.add(deletedItem); // restore
          _loadItems();
          Get.back();
          Get.snackbar(
            "Restored",
            "Item is back!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        child: const Text(
          "UNDO",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}
