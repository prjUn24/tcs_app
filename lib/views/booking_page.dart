import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Map<String, dynamic> _formData = {};
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Personal Details:",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 13.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Patient Name
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Patient Name',
                      labelStyle: const TextStyle(
                        color: Color(0xff567A9B),
                      ),
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
                        ),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the patient name' : null,
                    onSaved: (value) => _formData['name'] = value,
                  ),

                  const SizedBox(
                    height: 13.0,
                  ),

                  //Age
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Patient Age',
                      labelStyle: const TextStyle(
                        color: Color(0xff567A9B),
                      ),
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
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter the age' : null,
                    onSaved: (value) => _formData['age'] = value,
                  ),

                  const SizedBox(
                    height: 13.0,
                  ),

                  //Gender
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: const TextStyle(
                        color: Color(
                          0xff567A9B,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff567A9B), width: 1.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFFFCCBF3), width: 2.0),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    dropdownColor: const Color(0xffF5FAF9),
                    style: const TextStyle(
                        color: Color(
                      0xff567A9B,
                    )),
                    focusColor: const Color(0xFFFCCBF3),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                            value: gender, child: Text(gender)))
                        .toList(),
                    onChanged: (value) => _formData['gender'] = value,
                    validator: (value) =>
                        value == null ? 'Please select a gender' : null,
                  ),
                  const SizedBox(
                    height: 13.0,
                  ),

                  //Phone Number

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      labelStyle: const TextStyle(
                        color: Color(0xff567A9B),
                      ),
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
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a contact number' : null,
                    onSaved: (value) => _formData['contact'] = value,
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   _BookingPageState createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   final _formKey = GlobalKey<FormState>();
//   final Map<String, dynamic> _formData = {};

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       // Send _formData to the backend
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Booking Submitted')),
//       );
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Now'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: 'Condition/Reason'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please describe the condition' : null,
//                 onSaved: (value) => _formData['condition'] = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Address'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter the address' : null,
//                 onSaved: (value) => _formData['address'] = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Contact Number'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter a contact number' : null,
//                 onSaved: (value) => _formData['contact'] = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Date & Time'),
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter the date and time' : null,
//                 onSaved: (value) => _formData['datetime'] = value,
//               ),
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: 'Additional Notes'),
//                 maxLines: 3,
//                 onSaved: (value) => _formData['notes'] = value,
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _submitForm,
//                     child: const Text('Submit Booking'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
