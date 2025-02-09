import 'package:flutter/material.dart';

class TextArea extends StatefulWidget {
  const TextArea({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obsureText,
    this.hintColor,
    this.borderColor,
    this.textColor,
  });

  final String hintText;
  final TextEditingController controller;
  final bool obsureText;
  final Color? hintColor;
  final Color? borderColor;
  final Color? textColor;

  @override
  _TextAreaState createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible =
        widget.obsureText; // Initialize based on the passed value
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      elevation: 3,
      child: TextField(
        obscureText: _isPasswordVisible,
        controller: widget.controller,
        style: TextStyle(
          color: widget.textColor ?? colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintColor ?? colorScheme.onSurface.withOpacity(0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: widget.borderColor ?? colorScheme.primary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 3,
              color: widget.borderColor ?? colorScheme.primary,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          suffixIcon: widget.obsureText
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: colorScheme.onSurface,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
