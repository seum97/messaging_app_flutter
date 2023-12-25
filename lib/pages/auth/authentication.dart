
import 'package:flutter/material.dart';
import 'package:new_messaging_app/pages/auth/register.dart';

import 'login.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  bool showLoginPage = true;
  togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Send either in login page or in register page
    if (showLoginPage) {
      return LogIn(togglePage: togglePage);
    } else {
      return Register(togglePage: togglePage);
    }
  }
}
