import 'package:flutter/material.dart';

class MuscleCard extends StatelessWidget {
  final String muscle;
  final String imagePath;
  final VoidCallback onPressed;

  const MuscleCard({
    super.key, 
    required this.muscle,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Text(
              muscle,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}