import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs/views/width_and_height.dart';

class OtpFormField extends StatelessWidget {
  const OtpFormField({super.key, required this.otpValue});

  final TextEditingController otpValue;

  @override
  Widget build(BuildContext context) {
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
          onSaved: (newValue) {},
          onTap: () {},
          decoration: InputDecoration(
            hintText: '0',
            hintStyle:
                const TextStyle(color: Color.fromARGB(113, 158, 158, 158)),
            contentPadding: EdgeInsets.symmetric(
              vertical: FrameSize.screenHeight * 0.015,
              // horizontal: FrameSize.screenWidth * 0.02,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.021),
              borderSide: BorderSide(
                  color: Colors.blue, width: FrameSize.screenWidth * 0.004),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.021),
              borderSide: BorderSide(
                  color: Colors.blue, width: FrameSize.screenWidth * 0.005),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(FrameSize.screenWidth * 0.021),
              borderSide: BorderSide(
                  color: Colors.grey, width: FrameSize.screenWidth * 0.004),
            ),
          ),
          style: Theme.of(context).textTheme.headlineLarge,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }
}
