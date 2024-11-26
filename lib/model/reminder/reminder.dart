import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1)
class Reminder extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String time;

  Reminder({required this.title, required this.date, required this.time});
}
