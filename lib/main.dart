import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mediscan/firebase_options.dart';
import 'package:mediscan/models/medicine_model.dart';
import 'package:mediscan/models/user_model.dart';
import 'package:mediscan/screens/pharmacy_interface/pharmacy_registeration_screen.dart';
import 'package:mediscan/screens/user_interface/location_screen.dart';
import 'package:mediscan/screens/user_interface/user_registeration_screen.dart';
import 'package:mediscan/screens/user_interface/scan_search_screen.dart';
import 'package:mediscan/screens/user_type_selection_screen.dart';

// final List<PharmacyModel> pharmacies = const [
//   PharmacyModel(
//     name: 'hekma',
//     mobilePhone: '01095623566',
//     image: 'assets/pharmacies/pharmacy1.jpg',
//     long: 31.1686461,
//     lat: 30.4739836,
//     location: '3 anwar street , benha ',
//   ),
//   PharmacyModel(
//     name: 'Teba',
//     mobilePhone: '01095623566',
//     image: 'assets/pharmacies/pharmacy2.jpg',
//     long: 31.1691366,
//     lat: 30.4751885,
//     location: '3 anwar street , benha ',
//   ),
//   PharmacyModel(
//     name: 'Elnoor',
//     mobilePhone: '01095020566',
//     image: 'assets/pharmacies/pharmacy3.avif',
//     long: 31.1677811,
//     lat: 30.4742304,
//     location: '3 anwar street , benha ',
//   ),
//   PharmacyModel(
//     name: 'Rahma',
//     mobilePhone: '01095623666',
//     image: 'assets/pharmacies/pharmacy4.jpeg',
//     long: 31.1777431,
//     lat: 30.4728589,
//     location: '3 anwar street , benha ',
//   ),
//   PharmacyModel(
//     name: 'Delta',
//     mobilePhone: '01095989866',
//     image: 'assets/pharmacies/pharmacy5.jpg',
//     long: 31.1681338,
//     lat: 30.4738148,
//     location: '3 anwar street , benha ',
//   ),
// ];

// Future<void> addPharmacies() async {
//   final collection = FirebaseFirestore.instance.collection('pharmacies');

//   for (final pharmacy in pharmacies) {
//     await collection.add(pharmacy.toMap());
//   }

//   print('✅ Added all pharmacies to Firestore');
// }
// Future<void> addMedicinesToPharmacies() async {
//   final firestore = FirebaseFirestore.instance;

//   final medicines = [
//     MedicineModel(
//       name: 'Panadol',
//       price: 20.0,
//       quantity: 10,
//       image: 'assets/medicine/panadol.jpg',
//     ),
//     MedicineModel(
//       name: 'Amoxil',
//       price: 35.0,
//       quantity: 5,
//       image: 'assets/medicine/amoxil.jpeg',
//     ),
//     MedicineModel(
//       name: 'Vitamin',
//       price: 15.0,
//       quantity: 8,
//       image: 'assets/medicine/vitamin.jpeg',
//     ),
//     MedicineModel(
//       name: 'flagyl',
//       price: 15.0,
//       quantity: 8,
//       image: 'assets/medicine/flagyl.jpeg',
//     ),
//   ];

//   final pharmacies = await firestore.collection('pharmacies').get();

//   for (final pharmacy in pharmacies.docs) {
//     final productsCollection = firestore
//         .collection('pharmacies')
//         .doc(pharmacy.id)
//         .collection('products');

//     for (final med in medicines) {
//       await productsCollection.doc(med.name.toLowerCase()).set(med.toMap());
//     }

//     print('✅ Added medicines to pharmacy: ${pharmacy.id}');
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // addPharmacies();
  // await addMedicinesToPharmacies();

  runApp(
    DevicePreview(
      enabled: false, // Set to false to disable it in production
      builder: (context) => const Mediscan(),
    ),
  );
}

class Mediscan extends StatelessWidget {
  const Mediscan({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: DevicePreview.appBuilder,
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      home: UserTypeSelectionScreen(),
    );
  }
}
