// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcs/views/width_and_height.dart';

class GradientAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const GradientAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    FrameSize.init(context: context);
    return PreferredSize(
        preferredSize: Size.fromHeight(FrameSize.screenHeight * 0.01),
        child: Container(
          height: FrameSize.screenHeight * 0.07,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff5F6F65),
                Color.fromARGB(255, 150, 192, 209),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(FrameSize.screenWidth * 0.02),
                child: Image(
                  width: FrameSize.screenWidth * 0.2,
                  image: const AssetImage(
                    "lib/images/tcs.png",
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                padding: const EdgeInsets.only(right: 16.0),
                icon: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.onSurface.withValues(alpha: .1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    color: colorScheme.surface,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(FrameSize.screenHeight * 0.1);
}
