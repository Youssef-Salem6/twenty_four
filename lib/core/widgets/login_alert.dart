import 'package:flutter/material.dart';
import 'package:twenty_four/features/auth/view/login_view.dart';

class LoginAlert extends StatelessWidget {
  const LoginAlert({super.key});

  // Static method to show the alert
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) => const LoginAlert(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.login_rounded, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          Text(
            'تسجيل الدخول مطلوب',
            style: TextStyle(
              fontFamily: "Almarai",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ],
      ),
      content: Text(
        'يجب عليك تسجيل الدخول للوصول إلى هذه الميزة',
        style: TextStyle(
          fontFamily: "Almarai",
          fontSize: 16,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[300]
                  : Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[400]!, width: 1),
            ),
          ),
          child: Text(
            'إلغاء',
            style: TextStyle(
              fontFamily: "Almarai",
              fontSize: 16,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[700],
            ),
          ),
        ),

        // Login Button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Text(
            'تسجيل الدخول',
            style: TextStyle(
              fontFamily: "Almarai",
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
