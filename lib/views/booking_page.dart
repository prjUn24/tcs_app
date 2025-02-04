// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:tcs/services/booking_funtion.dart';
import 'package:tcs/widgets/address_field.dart';
import 'package:tcs/widgets/button.dart';
import 'package:tcs/widgets/date_picker.dart';
import 'package:tcs/widgets/drop_down_feild.dart';
import 'package:tcs/widgets/text_form_feild.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Booking Funtion Class object
  final BookingService _bookingService = BookingService();

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "patientName": "",
    "age": "",
    "gender": "",
    "contact": "",
    "address": "",
    "service": "",
    "condition": "",
    "startDate": "",
    "endDate": "",
  };

  //Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController careNeedController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //Date picker controller
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();

  String? nameError;
  String? ageError;
  String? genderError;
  String? contactError;
  String? addressError;
  String? careNeedError;
  String? selectedGender;
  String? selectedService;
  String? serviceError;
  String? startDateError;
  String? endDateError;

  void validateAndStoreForm() async {
    bool isValid = true;
    setState(() {
      // Validation logic

      // Validate name
      if (nameController.text.isEmpty) {
        nameError = "Please enter the name";
        isValid = false;
      } else {
        nameError = null;
      }

      // Validate age
      if (ageController.text.isEmpty) {
        ageError = "Please enter the age";
        isValid = false;
      } else {
        ageError = null;
      }

      // Validate gender
      if (selectedGender == null) {
        genderError = "Please select a gender";
        isValid = false;
      } else {
        genderError = null;
        // Gender is already stored in selectedGender
      }

      // Validate contact number
      if (contactNumberController.text.isEmpty) {
        contactError = "Please enter a contact number";
        isValid = false;
      } else {
        contactError = null;
      }

      // Validate address number
      if (addressController.text.isEmpty) {
        addressError = "Please enter the Address";
        isValid = false;
      } else {
        addressError = null;
      }

      // Validate Choose Service
      if (selectedService == null) {
        serviceError = "Please select a service";
        isValid = false;
      } else {
        serviceError = null;
      }

      // Validate care Need
      if (careNeedController.text.isEmpty) {
        careNeedError = "Please Describe why do you need the care";
      } else {
        careNeedError = null;
      }

      // Validate start date
      if (_startDate.text.isEmpty) {
        startDateError = "Please choose the start date";
      } else {
        startDateError = null;
      }
      // Validate end date
      if (_endDate.text.isEmpty) {
        endDateError = "Please choose the start date";
      } else {
        endDateError = null;
      }
    });

    // If all fields are valid, perform the next action

    if (isValid) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        try {
          // Save form data to Firestore
          await _bookingService.createBooking(_formData);
          // await FirebaseFirestore.instance
          //     .collection('bookings')
          //     .add(_formData);
          // print("Data saved successfully: $_formData");

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Booking submitted successfully!"),
            ),
          );

          // Clear form fields
          nameController.clear();
          ageController.clear();
          contactNumberController.clear();
          addressController.clear();
          _startDate.clear();
          _endDate.clear();
          setState(() {
            _formData.clear();
          });
          Future.delayed(const Duration(seconds: 5));
          Navigator.pushNamed(context, '/booking_confirmation_page');
        } catch (e) {
          print("Error saving data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Failed to submit booking. Try again!",
              ),
            ),
          );
        }
      } else {
        print("Form validation failed.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5FAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xffF8E8F5),
        centerTitle: true,
        title: const Text(
          "Care Booking",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Personal Details
                const Text(
                  "Patient Details:",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Patient Name
                    BookingTextFormFeild(
                      labelText: 'Patient Name',
                      errorText: nameError,
                      controller: nameController,
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.name,
                      onSaved: (value) => _formData['patientName'] = value,
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    //Age
                    BookingTextFormFeild(
                      labelText: 'Patient Age',
                      errorText: ageError,
                      controller: ageController,
                      prefixIcon: Icons.person,
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _formData['age'] = value,
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    //Gender
                    BookingDropDownFeild(
                      labelText: 'Gender',
                      errorText: genderError,
                      value: selectedGender,
                      prefixIcon: Icons.person,
                      items: const [
                        'Male',
                        'Female',
                        'Others',
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value; // Update state variable
                          _formData['gender'] =
                              value; // Optionally update _formData
                        });
                      },
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    //Phone Number
                    BookingTextFormFeild(
                      labelText: 'Contact Number',
                      errorText: contactError,
                      controller: contactNumberController,
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onSaved: (value) => _formData['contact'] = value,
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    //Address
                    AddressField(
                      labelText: "Address",
                      errorText: addressError,
                      controller: addressController,
                      onSaved: (value) => _formData['address'] = value,
                    ),
                  ],
                ),
                // Care Details
                const SizedBox(
                  height: 18.0,
                ),
                const Text(
                  "Care Details:",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),
                Column(
                  children: [
                    // Choose a Service
                    BookingDropDownFeild(
                      labelText: 'Choose a service',
                      errorText: serviceError,
                      value: selectedService,
                      prefixIcon: Icons.favorite,
                      items: const [
                        'In-Home Nursing care',
                        'Personal Care Assistance',
                        'Physical Therapy',
                        'Medication Management',
                        'Companion Care'
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedService = value; // Update state variable
                          _formData['service'] =
                              value; // Optionally update _formData
                        });
                      },
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    // Why do you need the service

                    BookingTextFormFeild(
                      labelText: 'Why do you need the service',
                      errorText: careNeedError,
                      controller: careNeedController,
                      prefixIcon: Icons.home_repair_service,
                      keyboardType: TextInputType.text,
                      onSaved: (value) => _formData['condition'] = value,
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
                // Duration
                const Text(
                  "Duration",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),

                Column(
                  children: [
                    //Start Date

                    BookingDatePicker(
                      labelText: "Start Date",
                      errorText: startDateError,
                      controller: _startDate,
                      onDateChanged: (value) {
                        setState(() {
                          _formData['startDate'] =
                              value; // Save start date in formData
                        });
                      },
                    ),
                    //End Date
                    const SizedBox(
                      height: 15.0,
                    ),
                    BookingDatePicker(
                      labelText: "End Date",
                      errorText: endDateError,
                      controller: _endDate,
                      onDateChanged: (value) {
                        setState(() {
                          _formData['endDate'] =
                              value; // Save end date in formData
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20.0,
                ),

                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 15.0,
                    children: [
                      ButtonTCS(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        txt: "Cancel",
                        color: const Color(0xffBDCFE7),
                        txtcolor: null,
                      ),
                      ButtonTCS(
                        onTap: () {
                          validateAndStoreForm();
                        },
                        txt: "Book Now",
                        txtcolor: null,
                        color: const Color(0xffB4D1B3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
