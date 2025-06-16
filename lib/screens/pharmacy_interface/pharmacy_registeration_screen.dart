import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_location_picker_flutter/map_location_picker_flutter.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/helper/custom_snack_bar.dart';
import 'package:mediscan/models/medicine_model.dart';
import 'package:mediscan/models/pharmacy_model.dart';
import 'package:mediscan/screens/pharmacy_interface/pharmacy_admin_screen.dart';
import 'package:mediscan/screens/pharmacy_interface/pharmacy_login_screen.dart';
import 'package:mediscan/screens/user_interface/location_screen.dart';
import 'package:mediscan/screens/user_interface/scan_search_screen.dart';
import 'package:mediscan/widgets/basic_text_form.dart';
import 'package:mediscan/widgets/identification_column.dart';
import 'package:mediscan/widgets/login_regist_button.dart';
import 'package:mediscan/widgets/shift_line.dart';

class PharmacyRegisterScreen extends StatefulWidget {
  const PharmacyRegisterScreen({super.key});

  @override
  State<PharmacyRegisterScreen> createState() => _PharmacyRegisterScreenState();
}

class _PharmacyRegisterScreenState extends State<PharmacyRegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  // final TextEditingController latController = TextEditingController();
  // final TextEditingController longController = TextEditingController();

  // final List<MedicineModel> defaultMedicines = [
  //   MedicineModel(name: 'Paracetamol', quantity: 100, price: 10.0),
  //   MedicineModel(name: 'Aspirin', quantity: 50, price: 15.0),
  // ];

  bool _isLoading = false;
  bool isHidden = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Position? position;
  double? long, lat;

  Future<void> registerPharmacy() async {
    setState(() => _isLoading = true);
    try {
      // 1. Register user with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController1.text.trim(),
          );
      final uid = userCredential.user!.uid;

      // 2. Create PharmacyModel instance (without medicines for now)
      final pharmacy = PharmacyModel(
        name: nameController.text.trim(),
        uid: uid,
        phone: phoneController.text.trim(),
        image: 'assets/pharmacies/pharmacy3.jpg', // default image for now
        address: addressController.text.trim(),
        lat: position?.latitude ?? lat!,
        long: position?.longitude ?? long!,
        medicines: null,
      );

      // 3. Save to Firestore with GeoPoint for location
      await FirebaseFirestore.instance
          .collection('pharmacies')
          .doc(uid)
          .set(pharmacy.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pharmacy registered successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PharmacyAdminScreen(pharmacyModel: pharmacy),
        ),
      );

      // Optionally, navigate to another screen here
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _handleLocation(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      position = await _determinePosition();
      //لو اتعملها ديسبوز ارجع
      if (!mounted) return;
      // List<Placemark> placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );
      // Placemark place = placemarks[3];
      customSnackBar(context, 'location is accessed correctly');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child:
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const IdentificationColumn(columnTitle: 'Sign Up'),
                          BasicTextForm(
                            customHint: 'Pharmacy Name',
                            keyboardType: TextInputType.name,
                            isHidden: false,
                            controller: nameController,
                          ),
                          BasicTextForm(
                            customHint: 'Phone',
                            keyboardType: TextInputType.phone,
                            isHidden: false,
                            controller: phoneController,
                          ),
                          BasicTextForm(
                            customHint: 'Address',
                            keyboardType: TextInputType.streetAddress,
                            isHidden: false,
                            controller: addressController,
                          ),
                          BasicTextForm(
                            customHint: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            isHidden: false,
                            controller: emailController,
                          ),
                          BasicTextForm(
                            customHint: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            isHidden: isHidden,
                            controller: passwordController1,
                            suffixIcon: IconButton(
                              onPressed: () {
                                isHidden = !isHidden;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          BasicTextForm(
                            customHint: 'Confirm Password',
                            keyboardType: TextInputType.visiblePassword,
                            isHidden: isHidden,
                            controller: passwordController2,
                            suffixIcon: IconButton(
                              onPressed: () {
                                isHidden = !isHidden;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // BasicTextForm(
                          //   customHint: 'Latitude',
                          //   keyboardType: TextInputType.number,
                          //   isHidden: false,
                          //   controller: latController,
                          // ),
                          // BasicTextForm(
                          //   customHint: 'Longitude',
                          //   keyboardType: TextInputType.number,
                          //   isHidden: false,
                          //   controller: longController,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LocationSizedBox(
                                width: 260,
                                isLoading: _isLoading,
                                onPressed: () => _handleLocation(context),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: kSecandryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: MapButton(
                                  onPressed: () async {
                                    LocationResult? result =
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    MapLocationPicker(),
                                          ),
                                        );

                                    if (result != null) {
                                      long = result.coordinates!.longitude;
                                      lat = result.coordinates!.latitude;
                                      customSnackBar(
                                        context,
                                        'location is accessed correctly',
                                      );

                                      // customSnackBar(
                                      //   context,
                                      //   'your address is ${result.getNearByString}',
                                      // );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          LoginRegistButton(
                            buttonText: 'Sign Up',
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (passwordController1.text ==
                                    passwordController2.text) {
                                  if (position?.latitude == null &&
                                      lat == null) {
                                    customSnackBar(
                                      context,
                                      'Give Us your Location',
                                    );
                                  } else {
                                    registerPharmacy();
                                  }
                                } else {
                                  customSnackBar(
                                    context,
                                    'Try to match Passwords',
                                  );
                                }
                              }
                            },
                          ),
                          ShiftLine(
                            questionText: 'already have account ?',
                            clickText: 'Login Now',
                            screen: PharmacyLoginScreen(),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
