import 'package:flutter/material.dart';

class BookingDetails extends StatefulWidget {
  final String title;
  final String bookingStatus;
  const BookingDetails(
      {super.key, required this.title, required this.bookingStatus});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
                fontSize: 25.0,
                color: Color(0xff567A9B),
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            padding: const EdgeInsets.all(25.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xffF8F8FF),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.grey.withOpacity(0.5), // Shadow color with opacity
                  spreadRadius: 1, // How wide the shadow spreads
                  blurRadius: 6, // Softness of the shadow
                  offset: const Offset(0, 1), // Position of the shadow (x, y)
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.bookingStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
