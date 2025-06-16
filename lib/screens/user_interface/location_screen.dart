import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/helper/custom_snack_bar.dart';
import 'package:mediscan/models/user_model.dart';
import 'package:mediscan/screens/user_interface/scan_search_screen.dart';
import 'package:map_location_picker_flutter/map_location_picker_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.userModel});
  final UserModel userModel;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = false;
  double? long, lat;
  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _handleLocation(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final position = await _determinePosition();
      //لو اتعملها ديسبوز ارجع
      if (!mounted) return;
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[3];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ScanSearchScreen(
                placemark: place,
                lat: position.latitude,
                long: position.longitude,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Location',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          MapButton(
            onPressed: () async {
              LocationResult? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapLocationPicker()),
              );

              if (result != null) {
                long = result.coordinates!.longitude;
                lat = result.coordinates!.latitude;

                // customSnackBar(
                //   context,
                //   'your address is ${result.getNearByString}',
                // );
                List<Placemark> placemarks = await placemarkFromCoordinates(
                  lat!,
                  long!,
                );
                Placemark place = placemarks[3];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ScanSearchScreen(
                          placemark: place,
                          lat: lat!,
                          long: long!,
                        ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: kPrimarybgColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.green[100],
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi ${widget.userModel.name} 👋',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                "Welcome to ",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Mediscan",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 120),
                Icon(Icons.my_location, size: 100, color: kPrimaryColor),
                const SizedBox(height: 30),
                const Text(
                  "Get your current location",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Allow us to access your location to proceed",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                LocationSizedBox(
                  isLoading: _isLoading,
                  onPressed: () => _handleLocation(context),
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'field is required';
                    }
                    return null;
                  },
                  controller: controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final locations = await locationFromAddress(
                            controller.text,
                          );
                          long = locations.first.longitude;
                          lat = locations.first.latitude;
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(lat!, long!);
                          Placemark place = placemarks[1];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ScanSearchScreen(
                                    placemark: place,
                                    lat: lat!,
                                    long: long!,
                                  ),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.send, color: kPrimaryColor),
                    ),
                    label: Text(
                      'Different location',
                      style: TextStyle(fontSize: 16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: kPrimaryColor),
                    ),
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

class MapButton extends StatelessWidget {
  const MapButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(CupertinoIcons.location_solid, color: Colors.black, size: 28),
    );
  }
}

class LocationSizedBox extends StatelessWidget {
  const LocationSizedBox({
    super.key,
    required bool isLoading,
    required this.onPressed,
    this.width = double.infinity,
  }) : _isLoading = isLoading;

  final bool _isLoading;
  final void Function()? onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon:
            _isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Icon(Icons.place, size: 30, color: Colors.black),
        label: Text(
          _isLoading ? "Locating..." : "Use My Location",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: _isLoading ? null : onPressed,
      ),
    );
  }
}
