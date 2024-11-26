import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  /// Hashes a plain text password using SHA-256
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final digest = sha256.convert(bytes); // Generate SHA-256 hash
    return digest.toString(); // Return the hashed string
  }

  /// Compares a plain text password with a hashed password
  bool verifyPassword(String plainPassword, String hashedPassword) {
    final hashedInput = hashPassword(plainPassword); // Hash the input password
    return hashedInput == hashedPassword; // Compare with the stored hash
  }
}
