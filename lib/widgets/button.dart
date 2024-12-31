import 'package:flutter/material.dart';

class ButtonTCS extends StatelessWidget {
  final Function()? onTap;
  final String txt;
  final Color? color;
  const ButtonTCS(
      {super.key, required this.onTap, required this.txt, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              txt,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
