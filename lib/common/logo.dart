import 'package:flutter/material.dart';

class GymLogo extends StatelessWidget {
  const GymLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: Image.asset(
          "assets/images/gym_logo.png",
          width: 200,
        ),
      ),
    );
  }
}