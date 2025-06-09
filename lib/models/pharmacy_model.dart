import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mediscan/models/medicine_model.dart';

class PharmacyModel {
  final String name;
  final String uid;
  final String phone;
  final String image;
  final double lat;
  final double long;
  final String address;
  final List<MedicineModel>? medicines;

  PharmacyModel({
    required this.name,
    required this.uid,
    required this.phone,
    required this.image,
    required this.lat,
    required this.long,
    required this.address,
    this.medicines,
  });

  factory PharmacyModel.fromMap(
    Map<String, dynamic> map, {
    List<MedicineModel>? medicines,
  }) {
    GeoPoint location = map['location'] ?? const GeoPoint(0.0, 0.0);

    return PharmacyModel(
      name: map['name'] ?? 'Unknown Name',
      uid: map['uid'] ?? '123',
      phone: map['phone'] ?? '0000000000',
      image: map['image'] ?? 'assets/pharmacies/default.jpg',
      address: map['address'] ?? 'No Address',
      lat: location.latitude,
      long: location.longitude,
      medicines: medicines,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'phone': phone,
      'image': image,
      'address': address,
      'location': GeoPoint(lat, long),
      // You can optionally add medicines here if you plan to save them
    };
  }
}
