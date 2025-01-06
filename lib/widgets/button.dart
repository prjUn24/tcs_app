import 'package:flutter/material.dart';

class ButtonTCS extends StatelessWidget {
  final Function()? onTap;
  final String txt;
  final Color? txtcolor;
  final Color? color;
  const ButtonTCS(
      {super.key,
      required this.onTap,
      required this.txt,
      required this.color,
      required this.txtcolor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
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
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: txtcolor),
            ),
          ),
        ),
      ),
    );
  }
}
