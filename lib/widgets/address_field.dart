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
  @override
  void initState() {
    super.initState();
    // _showPermissionDialog();
    // controller.addListener((){
    //   _onChange();
    // })
    _determinePosition();
  }

  // var uuid = const Uuid();
  List<dynamic> listOfLocation = [];

  bool _isLoading = false;

  // _onChange(){
  //   placeSuggestion(controller.text);
  // }

  // void placeSuggestion(String input) async{
  //   const String apiKey = ""

  // }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check and request location permission
      final permissionStatus = await Permission.location.request();

      if (permissionStatus.isGranted) {
        // Get current location
        Position position = await Geolocator.getCurrentPosition();

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
