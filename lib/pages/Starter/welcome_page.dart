// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:powerstone/common/logo.dart';
import 'package:powerstone/pages/Starter/LoginPage.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              const GymLogo(),
              const Spacer(flex: 5),
              Text(
                "Welcome to Power Stone",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                "Forge Your Power, Sculpt Your Stone",
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Spacer(flex: 8),
              const _Login(),
              const SizedBox(height: 8),
              const _contactInstructor(),
              const Spacer(flex:2),
            ],
          ),
        ),
      ),
    );
  }
}



class _contactInstructor extends StatelessWidget {
  const _contactInstructor();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: Center(
          child: Text(
            "Contact Instructor",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}

class _Login extends StatelessWidget {
  const _Login();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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
    );
  }
}