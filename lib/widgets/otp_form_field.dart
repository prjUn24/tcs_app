import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs/views/width_and_height.dart';

class OtpFormField extends StatelessWidget {
  const OtpFormField({super.key, required this.otpValue});

  final TextEditingController otpValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    FrameSize.init(context: context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: FrameSize.screenWidth * 0.019),
      child: SizedBox(
        height: FrameSize.screenHeight * 0.08,
        width: FrameSize.screenWidth * 0.109,
        child: TextFormField(
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).previousFocus();
            }
          },
          decoration: InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.5), // Subdued hint
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: FrameSize.screenHeight * 0.015,
            ),
            filled: true,
            fillColor: colorScheme.surface, // Surface for fill color
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.021),
              borderSide: BorderSide(
                color: colorScheme.primary, // Primary border color
                width: FrameSize.screenWidth * 0.004,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.021),
              borderSide: BorderSide(
                color: colorScheme.secondary, // Secondary color when focused
                width: FrameSize.screenWidth * 0.005,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.021),
              borderSide: BorderSide(
                color: colorScheme.onSurface.withOpacity(0.5), // Subdued border
                width: FrameSize.screenWidth * 0.004,
              ),
            ),
          ),
          style: TextStyle(color: colorScheme.onSurface), // Input text color
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: otpValue,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
