import 'package:flutter/material.dart';
import 'package:level_up_2/screen/auth/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? username;
  String? email;
  String? selectedTimeZone;
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  /// Menyimpan time zone di session
  Future<void> _saveTimeZoneSession(String timeZone) async {
    final prefs = await SharedPreferences.getInstance();

    final timeZones = {
      'wib': 'Asia/Jakarta',
      'wit': 'Asia/Jayapura',
      'wita': 'Asia/Makassar',
      'london': 'Europe/London',
    };

    await prefs.setString('timeZone', timeZones[timeZone.toLowerCase()]!);
  }

  // Menyimpan currency di session
  Future<void> _saveCurrencySession(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
      email = prefs.getString('email');
      selectedTimeZone = prefs.getString('timeZone');
      selectedCurrency = prefs.getString('currency');
    });
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
        return 'WIB';
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void logout() {
    clearSession();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff1e1e1e),
      ),
      backgroundColor: const Color(0xff121212),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22.0, left: 26, right: 26),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE SECTION
                Container(
                  width: double.infinity,
                  height: 115,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      color: Color(0xff2d2d2d)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 130,
                        child: CircleAvatar(
                          radius: 45,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$username',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins'),
                          ),
                          Text(
                            '$email',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
                                fontSize: 14,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ACCOUNT INFORMATION SECTION
                const SizedBox(height: 12),
                const Text(
                  'Account Information',
                  style: TextStyle(
                      color: Color.fromARGB(255, 117, 117, 117),
                      fontSize: 18,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 12),

                // Account Username
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Username',
                          style: TextStyle(
                              color: Color.fromARGB(255, 117, 117, 117),
                              fontSize: 12,
                              fontFamily: 'Poppins'),
                        ),
                        Text(
                          '$username',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Account Email
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Email',
                          style: TextStyle(
                              color: Color.fromARGB(255, 117, 117, 117),
                              fontSize: 12,
                              fontFamily: 'Poppins'),
                        ),
                        Text(
                          '$email',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                ),

                //APP SETTINGS
                const SizedBox(height: 12),
                const Text(
                  'Settings',
                  style: TextStyle(
                      color: Color.fromARGB(255, 117, 117, 117),
                      fontSize: 18,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 12),

                // Time Setting
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time Zone',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            alignment: Alignment.centerRight,
                            value:
                                timeDisplay(selectedTimeZone ?? 'Asia/Jakarta'),
                            dropdownColor: const Color(0xff2d2d2d),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
                                fontSize: 16,
                                fontFamily: 'Poppins'),
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 42,
                              color: Colors.amberAccent,
                            ),
                            items: ['WIB', 'WIT', 'WITA', 'London']
                                .map((timeZone) => DropdownMenuItem<String>(
                                      value: timeZone,
                                      child: Text(timeZone),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                final timeZones = {
                                  'WIB': 'Asia/Jakarta',
                                  'WITA': 'Asia/Makassar',
                                  'WIT': 'Asia/Jayapura',
                                  'London': 'Europe/London',
                                };
                                final timeZoneValue = timeZones[value]!;

                                setState(() {
                                  selectedTimeZone = timeZoneValue;
                                });
                                _saveTimeZoneSession(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // CURRENCY SETTINGS
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Currency',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCurrency ?? 'IDR',
                            dropdownColor: const Color(0xff2d2d2d),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 117, 117, 117),
                                fontSize: 16,
                                fontFamily: 'Poppins'),
                            icon: const Icon(
                              Icons.arrow_drop_down_outlined,
                              size: 42,
                              color: Colors.amberAccent,
                            ),
                            items: ['IDR', 'EUR', 'JPY', 'GBP', 'USD']
                                .map((currency) => DropdownMenuItem<String>(
                                      value: currency,
                                      child: Text(currency),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCurrency = value;
                                });
                                _saveCurrencySession(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // LOGOUT SECTION
                const SizedBox(height: 12),
                const Text(
                  'Logout',
                  style: TextStyle(
                      color: Color.fromARGB(255, 117, 117, 117),
                      fontSize: 18,
                      fontFamily: 'Poppins'),
                ),
                const SizedBox(height: 12),

                InkWell(
                  onTap: logout,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Log out',
                            style: TextStyle(
                                color: Colors.red, fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
