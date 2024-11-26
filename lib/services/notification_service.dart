// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:hive/hive.dart';
// import 'package:level_up_2/model/reminder/reminder.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   late Box<Reminder> _reminderBox;

//   Future<void> initializeHive() async {
//     _reminderBox = await Hive.openBox<Reminder>('reminderBox');
//   }

//   Future<void> addReminder(Reminder reminder) async {
//     await _reminderBox.add(reminder);

//     // Menghitung waktu reminder
//     DateTime reminderTime = DateTime.parse("${reminder.date} ${reminder.time}");

//     // Menjadwalkan notifikasi 5 menit sebelum waktu reminder
//     await scheduleReminderNotification(reminderTime);
//   }

//   // Fungsi untuk mengonversi DateTime menjadi TZDateTime sesuai zona waktu
//   tz.TZDateTime convertToTZDateTime(DateTime dateTime, String timeZone) {
//     final location = tz.getLocation(timeZone);
//     return tz.TZDateTime.from(dateTime, location);
//   }

//   Future<void> scheduleReminderNotification(DateTime reminderTime) async {
//     final DateTime notificationTime =
//         reminderTime.subtract(const Duration(minutes: 1));

//     // Konversi waktu reminder ke zona waktu yang sesuai (misalnya Jakarta)
//     final tzDateTime = convertToTZDateTime(notificationTime, 'Asia/Jakarta');

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0, // ID notifikasi
//       'Reminder', // Judul notifikasi
//       '5 menit lagi sebelum waktunya!', // Isi notifikasi
//       tzDateTime, // Waktu notifikasi yang sudah dikonversi ke zona waktu
//       await notificationDetails(), // Menyediakan detail notifikasi
//       // Membolehkan notifikasi saat perangkat dalam keadaan idle
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation
//               .wallClockTime, // Interpretasi waktu sesuai waktu lokal
//       matchDateTimeComponents: DateTimeComponents.time,
//       androidScheduleMode: AndroidScheduleMode
//           .exactAllowWhileIdle, // Tentukan jenis waktu yang akan dicocokkan
//     );
//   }

//   Future<void> initNotification() async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         const AndroidInitializationSettings('logo');

//     var initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {},
//     );
//   }

//   Future showNotification(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     return flutterLocalNotificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }

//   Future<NotificationDetails> notificationDetails() async {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'reminder_channel', // Channel ID
//         'Reminder Notifications', // Channel Name
//         importance: Importance.max, // Pentingnya notifikasi
//         priority: Priority.high, // Prioritas tinggi
//         showWhen: false, // Menyembunyikan waktu pada notifikasi
//       ),
//     );
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('sma20');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return flutterLocalNotificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max));
  }
}
