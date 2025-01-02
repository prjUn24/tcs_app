import 'package:flutter/material.dart';

class TextArea extends StatelessWidget {
  const TextArea(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.obsureText});

  final String hintText;
  final controller;
  final bool obsureText;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(50)),
      elevation: 3,
      child: TextField(
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.transparent),
          ),
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}
