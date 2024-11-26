import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key});

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  String? currency;
  String? timezone;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timezone = prefs.getString('timeZone');
      currency = prefs.getString('currency');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestion'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff1e1e1e),
      ),
      backgroundColor: const Color(0xff121212),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const Text(
                'PEMROGRAMAN APLIKASI MOBILE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Kesan:\nMata kuliah pemrograman aplikasi mobile (PAM) menurut saya sangat MENGASYIKKAN.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Pesan:\nLebih mendetailkan materi apa saja yang dipelajari selama perkuliahan, yang akan dipergunakan untuk membuat project.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
