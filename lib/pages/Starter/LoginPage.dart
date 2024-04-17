// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:powerstone/common/logo.dart';
import 'package:powerstone/navigation_menu.dart';
import 'package:powerstone/pages/Starter/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passController = TextEditingController();
  //global
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
                child: Lottie.asset(
            'assets/lottie/security_walking.json',
            fit: BoxFit.contain,
          )))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StartPage()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
                color: Theme.of(context).primaryColor,
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: GymLogo()),
                      Text("Login",
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 10, width: double.infinity),
                      Text("Please sign in to continue",
                          style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(height: 30, width: double.infinity),
                      PhoneInput(phoneController: phoneController),
                      const SizedBox(height: 20, width: double.infinity),
                      PasswordInput(passController: passController),
                      const SizedBox(height: 30, width: double.infinity),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            const Duration(seconds: 1);
                            final String phone = phoneController.text;
                            final String password = passController.text;
                            await signInLogic(phone, password, context);
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20, width: double.infinity),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> signInLogic(
      String phone, String password, BuildContext context) async {
    //password and phone are present
    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Phone number and password are required',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    //validating password
    if (phone.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'Invalid phone number. Please enter a 10-digit number.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }
    //execute the firebase query
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("user")
          .where('phone', isEqualTo: phone)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
        });
        // Phone number not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'Phone Number Not Found',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userDoc = querySnapshot.docs.first;
      final userPassword = userDoc.data()['password'];

      if (userPassword != password) {
        setState(() {
          isLoading = false;
        });
        // Password doesn't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                'Password Does Not Match',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // If phone number and password are correct, navigate to the next screen and save the docID of the user
      await prefs.setString('userID', userDoc.id);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NavigationMenu()));
    } catch (e) {
      // Handle other exceptions
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(
              'An Error Occurred',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    super.key,
    required this.phoneController,
  });

  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: phoneController,
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
          label: const Text("Phone Number"),
          labelStyle: Theme.of(context).textTheme.labelSmall,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: const BorderSide(color: Colors.white, width: 0.5)),
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color:
                  Theme.of(context).primaryColor, // Border color when focused
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.passController,
  });

  final TextEditingController passController; //local

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: TextField(
        controller: passController,
        style: Theme.of(context).textTheme.labelMedium,
        decoration: InputDecoration(
          label: const Text("Passowrd"),
          labelStyle: Theme.of(context).textTheme.labelSmall,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: const BorderSide(color: Colors.white, width: 0.5)),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
