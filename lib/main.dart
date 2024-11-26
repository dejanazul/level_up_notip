import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:level_up_2/model/reminder/reminder.dart';
import 'package:level_up_2/model/user/user.dart';
import 'package:level_up_2/screen/auth/login_screen.dart';
import 'package:level_up_2/screen/navigator/navigator.dart';
import 'package:level_up_2/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  // Initialize Hive (uses default directory)l
  await Hive.initFlutter();

  // Register Adapter
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ReminderAdapter());

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool? session = false;
  @override
  void initState() {
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      session = prefs.getBool('isLoggedIn');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child:
              session == true ? const NavigatorScreen() : const LoginScreen(),
        ),
      ),
    );
  }
}
