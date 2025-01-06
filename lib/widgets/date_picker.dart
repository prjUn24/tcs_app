import 'package:flutter/material.dart';

class BookingDatePicker extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  const BookingDatePicker({
    super.key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<BookingDatePicker> createState() => _BookingDatePickerState();
}

class _BookingDatePickerState extends State<BookingDatePicker> {
  Future<void> _selectDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        prefixIcon: const Icon(Icons.calendar_month),
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
      ),
      controller: widget.controller,
      readOnly: true,
      onTap: () {
        _selectDatePicker();
      },
    );
  }
}
