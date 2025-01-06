import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  //Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController careNeedController = TextEditingController();

  String? nameError;
  String? ageError;
  String? genderError;
  String? contactError;
  String? careNeedError;
  String? selectedGender;
  String? selectedService;
  String? serviceError;

  void validateAndStoreForm() {
    setState(() {
      // Validation logic
      bool isValid = true;

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

      // If all fields are valid, perform the next action
      if (isValid) {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          // Send _formData to the backend
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking Submitted')),
          );
          Navigator.pop(context);
        }
      }
    });
  }

// Function to validate and show errors
  void validateForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Send _formData to the backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Submitted')),
      );
      Navigator.pop(context);
    }
    // setState(() {
    //    else {
    //     // Example validations

    //     if (ageController.text.isEmpty) {
    //       ageError = "Please enter the age";
    //     } else {
    //       ageError = null;
    //     }

    //     if (selectedGender == null) {
    //       genderError = "Please select a gender";
    //     } else {
    //       genderError = null;
    //     }
    //     if (selectedGender == null) {
    //       serviceError = "Please select a service";
    //     } else {
    //       serviceError = null;
    //     }

    //     if (contactNumberController.text.isEmpty) {
    //       contactError = "Please enter a contact number";
    //     } else {
    //       contactError = null;
    //     }

    //     if (careNeedController.text.isEmpty) {
    //       careNeedError = "Please Describe why do you need the care";
    //     } else {
    //       careNeedError = null;
    //     }
    //   }
    // });
  }

  //Date picker controller
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
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
                      onSaved: (value) => _formData['name'] = value,
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
                      onChanged: (value) => _formData['item'] = value,
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
                      onChanged: (value) => _formData['service'] = value,
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
                      controller: _startDate,
                    ),
                    //End Date
                    const SizedBox(
                      height: 15.0,
                    ),
                    BookingDatePicker(
                      labelText: "End Date",
                      controller: _endDate,
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
