import 'package:flutter/material.dart';

class Menuitem extends StatelessWidget {
  const Menuitem({super.key, required this.icon, required this.title,this.color});

  final IconData icon;
  final String title;
  final String ?color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          (color==null)?
          Icon(icon,color:Theme.of(context).scaffoldBackgroundColor,size: 30,):
          Icon(icon,color:Colors.red ,size: 30,),
          const SizedBox(width: 20,),
          (color==null)?
          Text(title,style: Theme.of(context).textTheme.labelMedium,):
          Text(title,style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.red),)
        ],
      ),
    );
  }
}
