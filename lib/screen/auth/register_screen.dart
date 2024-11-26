import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:level_up_2/model/user/user.dart';
import 'package:level_up_2/services/encryption_service.dart';
import 'login_screen.dart'; // Import LoginScreen

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final EncryptionService _encryptionService = EncryptionService();

  late Future<Box<User>> _userBoxFuture;

  @override
  void initState() {
    super.initState();
    // Initialize Hive Box
    _userBoxFuture = Hive.openBox<User>('userBox');
  }

  void _registerUser(Box<User> userBox) {
    final email = _emailController.text;
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('All fields are required.');
      return;
    }

    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    // Encrypt the password
    final hashedPassword = _encryptionService.hashPassword(password);
    final newUser = User(
      email: email,
      username: username,
      password: hashedPassword,
    );
    userBox.add(newUser);
    _showSuccess('Registration successful!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Box<User>>(
        future: _userBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing database: ${snapshot.error}'),
            );
          } else {
            final userBox = snapshot.data!;
            return _buildRegistrationForm(userBox);
          }
        },
      ),
    );
  }

  Widget _buildRegistrationForm(Box<User> userBox) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Get your ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'free ',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.amberAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'account',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 34),
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
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent)),
              hintText: 'example@company.com',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Username',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _usernameController,
            cursorColor: Colors.amberAccent,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent)),
              hintText: 'Your username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
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
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent)),
              hintText: 'Your password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Confirm Password',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            cursorColor: Colors.amberAccent,
            style: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amberAccent)),
              hintText: 'Confirm your password',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 42),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _registerUser(userBox),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style:
                        TextStyle(color: Colors.black, fontFamily: 'Poppins'),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.white54),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Login here.',
                      style: TextStyle(
                          fontFamily: 'Poppins', color: Colors.amberAccent),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
