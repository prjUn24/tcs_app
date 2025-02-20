import 'package:flutter/material.dart';
import 'package:tcs/views/width_and_height.dart';

class Bottomsheet extends StatefulWidget {
  final String name;
  final String service;
  final String startDate;
  final String endDate;
  final String consultation;
  const Bottomsheet({
    super.key,
    required this.name,
    required this.service,
    required this.startDate,
    required this.endDate,
    required this.consultation,
  });

  @override
  State<Bottomsheet> createState() => _BottomsheetState();
}

class _BottomsheetState extends State<Bottomsheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(FrameSize.screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.03),
                  Text(
                    'Booking Details',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.02),
                  _buildDetailItem(
                    icon: Icons.person_outline,
                    label: "Patient Name:",
                    value: widget.name.isEmpty ? "N/A" : widget.name,
                    colorScheme: colorScheme,
                  ),
                  _buildDetailItem(
                    icon: Icons.medical_services_outlined,
                    label: "Service:",
                    value: widget.service.isEmpty ? "N/A" : widget.service,
                    colorScheme: colorScheme,
                  ),
                  _buildDetailItem(
                    icon: Icons.local_hospital_outlined,
                    label: "Consultation:",
                    value: widget.consultation.isEmpty
                        ? "N/A"
                        : widget.consultation,
                    colorScheme: colorScheme,
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateCard(
                          context: context,
                          label: "Start Date",
                          date: widget.startDate,
                          color: colorScheme.primary.withOpacity(0.1),
                          icon: Icons.calendar_today,
                        ),
                      ),
                      SizedBox(width: FrameSize.screenWidth * 0.03),
                      Expanded(
                        child: _buildDateCard(
                          context: context,
                          label: "End Date",
                          date: widget.endDate,
                          color: colorScheme.secondary.withOpacity(0.1),
                          icon: Icons.event_available,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: FrameSize.screenHeight * 0.02),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: FrameSize.screenHeight * 0.01),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          SizedBox(width: FrameSize.screenWidth * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: FrameSize.screenHeight * 0.005),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateCard({
    required BuildContext context,
    required String label,
    required String date,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(FrameSize.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey[700]),
              SizedBox(width: FrameSize.screenWidth * 0.02),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: FrameSize.screenHeight * 0.01),
          Text(
            date,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
