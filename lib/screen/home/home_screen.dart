import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:level_up_2/model/reminder/reminder.dart';
import 'package:level_up_2/services/api_service.dart';
import 'package:level_up_2/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Reminder> _reminderBox;
  final List<Map<String, String>> reminders = []; // List of reminders
  final NotificationService _notificationService = NotificationService();
  bool isLoading = true;
  Map<String, dynamic>? cryptoPrices;
  final ApiService _apiService = ApiService();
  String timeZone = 'Asia/Jakarta'; // Default to WIB
  String currency = 'IDR'; // Default to IDR

  @override
  void initState() {
    super.initState();
    loadSession();
    fetchPrices();
    _initializeHive();
    // _notificationService.initNotification();
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    await reminder.delete(); // Deletes reminder from Hive
    setState(() {}); // Refresh UI
  }

  Future<void> _initializeHive() async {
    _reminderBox = await Hive.openBox<Reminder>('reminderBox');
    setState(() {});
  }

  String timeDisplay(String timeZone) {
    switch (timeZone) {
      case 'Asia/Jakarta':
        return 'WIB';
      case 'Asia/Makassar':
        return 'WITA';
      case 'Asia/Jayapura':
        return 'WIT';
      case 'Europe/London':
        return 'London';
      default:
        return 'null';
    }
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeZone = prefs.getString('timeZone') ?? 'Asia/Jakarta';
      currency = prefs.getString('currency') ?? 'IDR';
    });
    fetchPrices();
  }

  String _formatTime(DateTime time, String timeZone) {
    final location = timeZone;
    final timeInZone = time.toUtc().add(_timeZoneOffset(location));
    return "${timeInZone.hour.toString().padLeft(2, '0')}:"
        "${timeInZone.minute.toString().padLeft(2, '0')}:"
        "${timeInZone.second.toString().padLeft(2, '0')}";
  }

  /// Helper function to calculate timezone offset
  Duration _timeZoneOffset(String timeZone) {
    switch (timeZone) {
      case "Asia/Jakarta": // WIB
        return const Duration(hours: 7);
      case "Asia/Makassar": // WITA
        return const Duration(hours: 8);
      case "Asia/Jayapura": // WIT
        return const Duration(hours: 9);
      case "Europe/London": // London
        return const Duration(hours: 0); // UTC+0
      default:
        return Duration.zero;
    }
  }

  Future<void> fetchPrices() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Jika cache lama, ambil data baru
      final prices = await _apiService.fetchCryptoPrices(
        ids: "bitcoin,ethereum,binancecoin",
        vsCurrencies: currency.toLowerCase(),
      );
      prefs.setString('cachedPrices', jsonEncode(prices));
      setState(() {
        cryptoPrices = prices;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _showAddReminderDialog() async {
    final titleController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff2e2e2e),
          title: const Text(
            'Add Reminder',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.amberAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // Input title
                TextField(
                  controller: titleController,
                  cursorColor: Colors.amberAccent,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amberAccent)),
                    hintText: 'Reminder title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Select Date
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text(
                      'Select Date',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Select Time
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        selectedTime = pickedTime;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    child: const Text(
                      'Select Time',
                      style:
                          TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 100,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.amberAccent, fontFamily: 'Poppins'),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      selectedDate != null &&
                      selectedTime != null) {
                    final reminder = Reminder(
                      title: titleController.text,
                      date:
                          "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                      time: "${selectedTime!.hour}:${selectedTime!.minute}",
                    );

                    // Simpan ke Hive Box
                    await _reminderBox.add(reminder);

                    // _notificationService.scheduleReminderNotification(
                    //     DateTime.parse("${reminder.date} ${reminder.time}"));

                    NotificationService().showNotification(
                        title: 'Reminder Added!!!',
                        body: 'You have successfully add a reminder');

                    // Tutup dialog
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff1e1e1e),
      ),
      backgroundColor: const Color(0xff121212),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amberAccent,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show Time
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<DateTime>(
                            stream: Stream.periodic(const Duration(seconds: 1),
                                (_) => DateTime.now()),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                final currentTime = snapshot.data!;
                                return Text(
                                  _formatTime(currentTime, timeZone),
                                  style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontFamily: 'Poppins'),
                                );
                              } else {
                                return const CircularProgressIndicator(
                                  color: Colors.transparent,
                                );
                              }
                            },
                          ),
                          Text(
                            timeDisplay(timeZone),
                            style: const TextStyle(
                                fontSize: 40,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent,
                                fontFamily: 'Poppins'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Reminder',
                      style: TextStyle(
                        color: Color.fromARGB(255, 117, 117, 117),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),

                    ValueListenableBuilder(
                      valueListenable: _reminderBox.listenable(),
                      builder: (context, Box<Reminder> box, _) {
                        if (box.isEmpty) {
                          return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: const Center(
                                child: Text(
                                  'No reminder yet!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ));
                        }

                        return Column(
                          children: box.values.map((reminder) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Row(
                                children: [
                                  // Reminder Information
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            reminder.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          Text(
                                            "${reminder.date} ${reminder.time}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 117, 117, 117),
                                              fontSize: 12,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Delete Button
                                  IconButton(
                                    onPressed: () async {
                                      await _deleteReminder(
                                          reminder); // Call delete function
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    // Add Reminder Button
                    InkWell(
                      onTap: _showAddReminderDialog,
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.yellowAccent,
                          ),
                          color: const Color(0xff121212),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              size: 32,
                              color: Colors.amberAccent,
                            ),
                            Text(
                              'Add reminder',
                              style: TextStyle(color: Colors.amberAccent),
                            )
                          ],
                        ),
                      ),
                    ),

                    //CRYPTO
                    const SizedBox(height: 12),
                    const Text(
                      'Crypto update',
                      style: TextStyle(
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontSize: 18,
                          fontFamily: 'Poppins'),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xff2d2d2d),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Bitcoin
                            const Text(
                              'Bitcoin',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'BTC',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  cryptoPrices != null
                                      ? '${cryptoPrices!['bitcoin'][currency.toLowerCase()]} $currency'
                                      : 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            // Etherium
                            const Text(
                              'Ethereum',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ETH',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  cryptoPrices != null
                                      ? '${cryptoPrices!['ethereum'][currency.toLowerCase()]} $currency'
                                      : 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            // Binance Coin
                            const Text(
                              'Binance coin',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'BNB',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                Text(
                                  cryptoPrices != null
                                      ? '${cryptoPrices!['binancecoin'][currency.toLowerCase()]} $currency'
                                      : 'Loading...',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
    );
  }
}
