import 'package:flutter/material.dart';
import 'package:tcs/views/width_and_height.dart';

class ButtonTCS extends StatelessWidget {
  final Function()? onTap;
  final String txt;
  final Color? txtcolor;
  final Color? color;

  const ButtonTCS({
    super.key,
    required this.onTap,
    required this.txt,
    required this.color,
    required this.txtcolor,
  });

  @override
  Widget build(BuildContext context) {
    // You can directly set width and height here based on FrameSize
    double width = FrameSize.screenWidth * 0.4; // 40% of screen width
    double height = FrameSize.screenHeight * 0.07; // 7% of screen height

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            txt,
            style: TextStyle(
                fontFamily: 'ProximaNova',
                fontSize: width * 0.099,
                fontWeight: FontWeight.bold,
                color: txtcolor),
          ),
        ),
      ),
    );
  }
}
