
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:level_up_2/model/user/user.dart';
import 'package:level_up_2/screen/auth/register_screen.dart';
import 'package:level_up_2/screen/navigator/navigator.dart';
import 'package:level_up_2/services/encryption_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Box<User> _userBox;
  final EncryptionService _encryptionService = EncryptionService();

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    _userBox = await Hive.openBox<User>('userBox');
  }

  Future<void> addSession(String usn, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usn);
    await prefs.setString('email', email);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('currency', 'IDR');
    await prefs.setString('timeZone', 'Asia/Jakarta');
  }

  void _loginUser() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Email and password cannot be empty.');
      return;
    }

    User? user;
    try {
      user = _userBox.values.firstWhere((u) => u.email == email);
    } catch (e) {
      user = null;
    }

    if (user == null) {
      _showError('Invalid email or password.');
    } else if (!_encryptionService.verifyPassword(password, user.password)) {
      _showError('Invalid email or password.');
    } else {
      addSession(user.username, user.email);
      _showSuccess('Welcome back, ${user.username}!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavigatorScreen()),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
          )),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            message,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Row(
                children: [
                  Text(
                    'Log in to Level',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Up',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.amberAccent,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 34),

              // Email TextField
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                cursorColor: Colors.amberAccent,
                style:
                    const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent)),
                  hintText: 'example@company.com',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 22),

              // Password Textfield
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                cursorColor: Colors.amberAccent,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amberAccent)),
                  hintText: 'Your password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 42),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Poppins'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Register Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white54),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        child: const Text(
                          'Register here.',
                          style: TextStyle(
                              fontFamily: 'Poppins', color: Colors.amberAccent),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
