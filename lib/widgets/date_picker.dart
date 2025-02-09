import 'package:flutter/material.dart';

class BookingDatePicker extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String?)? onDateChanged;
  final String? errorText;

  const BookingDatePicker({
    super.key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.onDateChanged,
    this.errorText,
  });

  @override
  State<BookingDatePicker> createState() => _BookingDatePickerState();
}

class _BookingDatePickerState extends State<BookingDatePicker> {
  Future<void> _selectDatePicker() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set initial date to current date
      firstDate: DateTime.now(), // Disable past dates
      lastDate: DateTime(2100), // Set the maximum date
    );

    if (selectedDate != null) {
      // Format the date as 'YYYY-MM-DD'
      widget.controller.text = selectedDate.toIso8601String().split('T').first;

      // Trigger the onDateChanged callback if it is provided
      if (widget.onDateChanged != null) {
        widget.onDateChanged!(widget.controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        errorText: widget.errorText,
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
            width: 2.0,
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
            width: 2.0,
          ),
        ),
      ),
      controller: widget.controller,
      validator: widget.validator, // Support validation if provided
      readOnly: true, // Prevent manual input
      onTap: _selectDatePicker, // Open date picker on tap
    );
  }
}
