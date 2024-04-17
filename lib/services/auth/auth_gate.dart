// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:powerstone/navigation_menu.dart';
import 'package:powerstone/pages/Starter/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isLoggedIn = prefs.getString('userID') ?? '';
    if (isLoggedIn != '') {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const NavigationMenu())));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const StartPage())));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
