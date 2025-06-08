import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediscan/models/medicine_model.dart';
import 'package:mediscan/models/pharmacy_model.dart';
import 'package:mediscan/screens/pharmacy_screen.dart';
import 'package:mediscan/widgets/pharmacy_first_item.dart';

class PharmaciesScreen extends StatefulWidget {
  const PharmaciesScreen({
    super.key,
    required this.location,
    required this.medicine,
  });
  final Position location;
  final List<dynamic> medicine;

  @override
  State<PharmaciesScreen> createState() => _PharmaciesScreenState();
}

class _PharmaciesScreenState extends State<PharmaciesScreen> {
  List<PharmacyModel> nearPharmacies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print("Received medicines: ${widget.medicine}");

    getNearPharmaciesWithMedicines(widget.medicine);
  }

  Future<List<PharmacyModel>> getNearPharmaciesWithMedicines(
    List<dynamic> medicineNames,
  ) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('pharmacies').get();

    nearPharmacies.clear();

    for (var doc in snapshot.docs) {
      final pharmacyData = doc.data();
      final PharmacyModel pharmacy = PharmacyModel.fromMap(pharmacyData);

      // Calculate distance from current location
      double distance = Geolocator.distanceBetween(
        pharmacy.lat,
        pharmacy.long,
        widget.location.latitude,
        widget.location.longitude,
      );

      if (distance < 500) {
        // Get all medicines in this pharmacy
        final productsSnapshot =
            await doc.reference.collection('products').get();

        final List<MedicineModel> allMedicines =
            productsSnapshot.docs
                .map((medDoc) => MedicineModel.fromMap(medDoc.data()))
                .toList();

        // Filter medicines that match the searched names
        final matchedMedicines =
            allMedicines
                .where((med) => medicineNames.contains(med.name.toLowerCase()))
                .toList();

        if (matchedMedicines.isNotEmpty) {
          // Create a new pharmacy object with its medicines
          final pharmacyWithMedicines = PharmacyModel.fromMap(
            pharmacyData,
            medicines: matchedMedicines,
          );
          nearPharmacies.add(pharmacyWithMedicines);
          // pharmacies = pharmacyWithMedicines;
          // print(pharmacyWithMedicines.name);
        }
      }
    }

    setState(() => isLoading = false);
    return nearPharmacies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 70),
                    Text(
                      'your near pharmacies  🎯',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        itemBuilder:
                            (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => PharmacyScreen(
                                          pharmacyModel: nearPharmacies[index],
                                        ),
                                  ),
                                );
                              },
                              child: PharmacyFirstItem(
                                name: nearPharmacies[index].name,
                                image: nearPharmacies[index].image,
                              ),
                            ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                        itemCount: nearPharmacies.length,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
