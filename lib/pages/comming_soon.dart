import 'package:flutter/material.dart';

class CommingSoon extends StatelessWidget {
  const CommingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Comming Soon',style: Theme.of(context).textTheme.labelLarge,),
    );
  }
}