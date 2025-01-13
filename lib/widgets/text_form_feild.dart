import 'package:flutter/material.dart';

class BookingTextFormFeild extends StatefulWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String? errorText;

  const BookingTextFormFeild(
      {super.key,
      required this.labelText,
      this.validator,
      required this.onSaved,
      this.keyboardType,
      this.prefixIcon,
      required this.controller,
      this.errorText,
      this.suffixIcon});

  @override
  State<BookingTextFormFeild> createState() => _BookingTextFormFeildState();
}

class _BookingTextFormFeildState extends State<BookingTextFormFeild> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        filled: true,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: widget.suffixIcon,
        labelStyle: const TextStyle(
          color: Color(0xff567A9B),
        ),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xff567A9B),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xFFFCCBF3),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0, // Matches errorBorder width
          ),
        ),
      ),
      validator: widget.validator,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      onSaved: widget.onSaved,
    );
  }
}
