import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget {
  final String title;
  final String bookingStatus;
  const BookingDetails({
    super.key,
    required this.title,
    required this.bookingStatus,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 25.0,
              color: colorScheme.primary, // Primary color for the title
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            padding: const EdgeInsets.all(25.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.surface, // Surface color for the card
              boxShadow: [
                BoxShadow(
                  color:
                      colorScheme.onSurface.withOpacity(0.1), // Subtle shadow
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bookingStatus,
                  style: TextStyle(
                    color: colorScheme.onSurface, // Text color on surface
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
