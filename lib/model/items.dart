import 'package:hive/hive.dart';
part 'items.g.dart';

@HiveType(typeId: 0)
class Items extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String? description;

  Items({required this.title, this.description});

  Items copyWith({String? title, String? description}) {
    return Items(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}
