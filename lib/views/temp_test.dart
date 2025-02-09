// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:lottie/lottie.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:tcs/views/width_and_height.dart';

// // Add your existing imports and other necessary packages

// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen> {
//   // Your existing state variables and methods

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isDarkMode = theme.brightness == Brightness.dark;
    
//     FrameSize.init(context: context);
    
//     // Gradient colors for the app bar
//     final appBarGradient = LinearGradient(
//       colors: isDarkMode
//           ? [
//               colorScheme.primary.withOpacity(0.8),
//               colorScheme.primary.withOpacity(0.4),
//               colorScheme.primary.withOpacity(0.8),
//             ]
//           : [
//               const Color(0xffF9E6F3),
//               const Color(0xffFDF2FA),
//               const Color(0xffF9E6F3),
//             ],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );

//     return Scaffold(
//       appBar: AppBar(
//         leading: Container(
//           margin: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isDarkMode 
//                 ? colorScheme.surface.withOpacity(0.3)
//                 : Colors.white.withOpacity(0.9),
//             boxShadow: [
//               BoxShadow(
//                 color: isDarkMode
//                     ? colorScheme.primary.withOpacity(0.3)
//                     : Colors.pink.shade100,
//                 blurRadius: 6,
//                 spreadRadius: 2,
//               )
//             ],
//           ),
//           child: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_rounded,
//               color: isDarkMode ? colorScheme.onSurface : Colors.pink.shade800,
//               size: 20,
//             ),
//             onPressed: () => Navigator.pushNamed(context, '/home'),
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: appBarGradient,
//             boxShadow: [
//               BoxShadow(
//                 color: isDarkMode
//                     ? colorScheme.primary.withOpacity(0.2)
//                     : Colors.pink.shade100,
//                 blurRadius: 15,
//                 spreadRadius: 5,
//               )
//             ],
//             border: Border(
//               bottom: BorderSide(
//                 color: isDarkMode
//                     ? colorScheme.surface.withOpacity(0.2)
//                     : Colors.grey.shade200,
//                 width: 1,
//               ),
//             ),
//           ),
//         ),
//         centerTitle: true,
//         elevation: 8,
//         title: Text(
//           "My Account",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 22,
//             fontFamily: 'Poppins',
//             letterSpacing: 1.2,
//             color: isDarkMode ? colorScheme.onPrimary : Colors.pink.shade800,
//             shadows: [
//               Shadow(
//                 color: isDarkMode 
//                     ? colorScheme.primary.withOpacity(0.2)
//                     : Colors.white.withOpacity(0.5),
//                 blurRadius: 4,
//                 offset: const Offset(1, 1),
//               )
//             ],
//           ),
//         ),
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 15),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: isDarkMode
//                       ? colorScheme.primary.withOpacity(0.3)
//                       : Colors.pink.shade100,
//                   blurRadius: 6,
//                   spreadRadius: 2,
//                 )
//               ],
//             ),
//             child: IconButton(
//               iconSize: FrameSize.screenWidth * 0.07,
//               icon: Icon(
//                 Provider.of<ThemeProvider>(context).themeData == lightMode
//                     ? Icons.brightness_7
//                     : Icons.brightness_4,
//                 color: isDarkMode ? colorScheme.onSurface : Colors.pink.shade800,
//               ),
//               onPressed: () {
//                 Provider.of<ThemeProvider>(context, listen: false)
//                     .toggleTheme();
//               },
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               _buildProfileHeader(),
//               _buildUserInfoSection(),
//               _buildActionButtons(),
//               SizedBox(height: FrameSize.screenHeight * 0.03),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: _buildBottomNavBar(context, colorScheme),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Column(
//       children: [
//         Container(
//           margin: EdgeInsets.only(top: FrameSize.screenHeight * 0.03),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.pink.shade100.withOpacity(0.4),
//                 blurRadius: 15,
//                 spreadRadius: 5,
//               )
//             ],
//           ),
//           child: Lottie.asset(
//             'lib/images/user_new.json',
//             frameRate: const FrameRate(100),
//             repeat: false,
//             width: FrameSize.screenWidth * 0.3,
//           ),
//         ),
//         SizedBox(height: FrameSize.screenHeight * 0.02),
//         _buildUserNameSection(),
//         SizedBox(height: FrameSize.screenHeight * 0.02),
//       ],
//     );
//   }

//   Widget _buildUserNameSection() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: FrameSize.screenWidth * 0.05),
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(user!.uid)
//                     .snapshots(),
//                 builder: (context, userSnapshot) {
//                   // Your existing user name stream builder logic
//                   return Text(
//                     userSnapshot.hasData ? userData['name'] : 'Loading...',
//                     style: TextStyle(
//                       fontSize: FrameSize.screenWidth * 0.06,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                   );
//                 },
//               ),
//               if (toEdit)
//                 IconButton(
//                   icon: Icon(Icons.edit,
//                       color: Theme.of(context).colorScheme.primary),
//                   onPressed: () => _showNameEditDialog(context),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUserInfoSection() {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: FrameSize.screenWidth * 0.05,
//         vertical: FrameSize.screenHeight * 0.02,
//       ),
//       child: Column(
//         children: [
//           _buildInfoTile(
//             icon: Icons.email,
//             title: 'Email',
//             value: user?.email ?? 'N/A',
//             isEditable: user?.providerData[0].providerId != 'google.com',
//             onEdit: () => _showEmailEditDialog(context),
//           ),
//           _buildInfoTile(
//             icon: Icons.phone,
//             title: 'Phone',
//             value: userData['number'] ?? 'Not Provided',
//             isEditable: true,
//             onEdit: () => _showPhoneEditDialog(context),
//           ),
//           _buildInfoTile(
//             icon: Icons.home,
//             title: 'Address',
//             value: userData['address'] ?? 'Not Provided',
//             isEditable: true,
//             onEdit: () => _showAddressEditDialog(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoTile({
//     required IconData icon,
//     required String title,
//     required String value,
//     required bool isEditable,
//     required VoidCallback onEdit,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: Theme.of(context).colorScheme.primary),
//         ),
//         title: Text(
//           value,
//           style: TextStyle(
//             fontSize: 16,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//         ),
//         subtitle: Text(
//           title,
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//           ),
//         ),
//         trailing: isEditable && toEdit
//             ? IconButton(
//                 icon: Icon(Icons.edit_rounded,
//                     color: Theme.of(context).colorScheme.primary),
//                 onPressed: onEdit,
//               )
//             : null,
//       ),
//     );
//   }

//   Widget _buildActionButtons() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: FrameSize.screenWidth * 0.05),
//       child: Column(
//         children: [
//           if (!isGoogle)
//             _buildActionButton(
//               text: 'CHANGE PASSWORD',
//               onPressed: () => _showPasswordChangeDialog(context),
//               color: Theme.of(context).colorScheme.primaryContainer,
//             ),
//           SizedBox(height: FrameSize.screenHeight * 0.02),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildActionButton(
//                   text: 'SIGN OUT',
//                   onPressed: signUserOut,
//                   color: Theme.of(context).colorScheme.errorContainer,
//                 ),
//               ),
//               SizedBox(width: FrameSize.screenWidth * 0.03),
//               Expanded(
//                 child: _buildActionButton(
//                   text: 'DELETE ACCOUNT',
//                   onPressed: deleteUser,
//                   color: Theme.of(context).colorScheme.error.withOpacity(0.1),
//                   textColor: Theme.of(context).colorScheme.error,
//                 ),
//               ),
//             ],
//           ),
//           if (!emailVerified)
//             Padding(
//               padding: EdgeInsets.only(top: FrameSize.screenHeight * 0.02),
//               child: _buildActionButton(
//                 text: 'VERIFY EMAIL',
//                 onPressed: () => Navigator.pushNamed(context, '/verification'),
//                 color: Colors.amber.withOpacity(0.2),
//                 textColor: Colors.amber.shade800,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required String text,
//     required VoidCallback onPressed,
//     Color? color,
//     Color? textColor,
//   }) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color ?? Theme.of(context).colorScheme.primary,
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         elevation: 2,
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: textColor ?? Theme.of(context).colorScheme.onPrimary,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   BottomNavigationBar _buildBottomNavBar(
//       BuildContext context, ColorScheme colorScheme) {
//     return BottomNavigationBar(
//       elevation: 10,
//       backgroundColor: colorScheme.surface,
//       selectedItemColor: colorScheme.primary,
//       unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
//       currentIndex: 1,
//       type: BottomNavigationBarType.fixed,
//       selectedLabelStyle: TextStyle(
//         fontWeight: FontWeight.w600,
//         fontSize: FrameSize.screenWidth * 0.03,
//       ),
//       items: [
//         _buildNavItem(Icons.home_rounded, "Home"),
//         _buildNavItem(Icons.person_rounded, "Account"),
//       ],
//       onTap: (index) => _handleNavTap(context, index),
//     );
//   }

//   BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
//     return BottomNavigationBarItem(
//       icon: Container(
//         padding: EdgeInsets.all(FrameSize.screenWidth * 0.02),
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, size: FrameSize.screenWidth * 0.06),
//       ),
//       label: label,
//     );
//   }

//   void _handleNavTap(BuildContext context, int index) {
//     if (index == 0) Navigator.pushNamed(context, '/');
//     if (index == 1) Navigator.pushNamed(context, '/account_screen');
//   }

//   // Add your existing dialog methods (_showNameEditDialog, etc.)
//   // and Firebase interaction methods here
// }