import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tcs/widgets/text_form_feild.dart';

class AddressField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String labelText;
  final String? errorText;

  const AddressField({
    super.key,
    required this.controller,
    this.validator,
    required this.onSaved,
    required this.labelText,
    this.errorText,
  });

  @override
  State<AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<AddressField> {
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check and request location permission
      final permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        // Get current location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Reverse geocode to get address
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final address =
              "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}";

          // Fill the address field
          widget.controller.text = address;
        }
      } else if (permissionStatus.isDenied) {
        // Show dialog to explain why permission is needed
        _showPermissionDialog();
      } else if (permissionStatus.isPermanentlyDenied) {
        // Redirect to app settings
        await openAppSettings();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch location: $e"),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Permission Needed"),
        content: const Text(
            "This app needs location access to fetch your current address. Please grant the permission."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final permissionStatus = await Permission.location.request();
              if (permissionStatus.isGranted) {
                _getCurrentLocation(); // Retry fetching location
              }
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BookingTextFormFeild(
      labelText: widget.labelText,
      onSaved: widget.onSaved,
      controller: widget.controller,
      prefixIcon: Icons.location_on,
      errorText: widget.errorText,
      suffixIcon: _isLoading
          ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : GestureDetector(
              onTap: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
    );
  }
}
