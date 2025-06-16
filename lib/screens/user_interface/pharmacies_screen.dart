import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/models/medicine_model.dart';
import 'package:mediscan/models/pharmacy_model.dart';
import 'package:mediscan/screens/user_interface/pharmacy_screen.dart';
import 'package:mediscan/widgets/pharmacy_first_item.dart';

class PharmaciesScreen extends StatefulWidget {
  const PharmaciesScreen({
    super.key,
    required this.medicine,
    required this.lat,
    required this.long,
    required this.range,
  });
  final List<dynamic> medicine;
  final double lat, long;
  final String range;

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
        widget.lat,
        widget.long,
      );

      if (distance < double.parse(widget.range)) {
        // Get all medicines in this pharmacy
        final productsSnapshot =
            await doc.reference.collection('products').get();

        final List<MedicineModel> allMedicines =
            productsSnapshot.docs
                .map((medDoc) => MedicineModel.fromMap(medDoc.data()))
                .toList();

        // Filter medicines that match the searched names
        final List<MedicineModel> matchedMedicines =
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
      backgroundColor: kPrimarybgColor,
      appBar: AppBar(
        title: const Text(
          "Pharmacies",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        backgroundColor: kPrimaryColor,
      ),
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(
                      'Your Near Pharmacies  🎯',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 24),
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
                                          lat: widget.lat,
                                          long: widget.long,
                                          pharmacyModel: nearPharmacies[index],
                                        ),
                                  ),
                                );
                              },
                              child: PharmacyFirstItem(
                                allLenght: widget.medicine.length,
                                existLenght:
                                    nearPharmacies[index].medicines?.length ??
                                    0,
                                name: nearPharmacies[index].name,
                                image: nearPharmacies[index].image,
                              ),
                            ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
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
