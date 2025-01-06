import 'package:flutter/material.dart';

class BookingDropDownFeild extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final String? initialValue;
  final IconData? prefixIcon;
  final String? value;
  final String? errorText;

  const BookingDropDownFeild(
      {super.key,
      required this.labelText,
      required this.items,
      this.validator,
      this.onChanged,
      this.initialValue,
      this.prefixIcon,
      required this.value,
      required this.errorText
      });

  @override
  State<BookingDropDownFeild> createState() => _BookingDropDownFeildState();
}

class _BookingDropDownFeildState extends State<BookingDropDownFeild> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
        prefixIcon: Icon(widget.prefixIcon),
        labelStyle: const TextStyle(
          color: Color(0xff567A9B),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xff567A9B),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFFCCBF3),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      dropdownColor: const Color(0xffF5FAF9),
      style: const TextStyle(
        color: Color(0xff567A9B),
      ),
      focusColor: const Color(0xFFFCCBF3),
      items: widget.items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: widget.onChanged,
      validator: widget.validator,
      value: widget.value,
    );
  }
}
