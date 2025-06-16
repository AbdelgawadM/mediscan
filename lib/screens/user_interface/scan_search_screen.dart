import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/screens/user_interface/pharmacies_screen.dart';
import 'package:get/get.dart';

class ScanSearchScreen extends StatefulWidget {
  const ScanSearchScreen({
    super.key,
    required this.lat,
    required this.long,
    required this.placemark,
  });
  final double lat, long;
  final Placemark placemark;

  @override
  State<ScanSearchScreen> createState() => _ScanSearchScreenState();
}

class _ScanSearchScreenState extends State<ScanSearchScreen> {
  RxList<dynamic> scannedText = [].obs;
  RxBool isLoading = false.obs;
  TextEditingController medicinecontroller = TextEditingController();
  TextEditingController rangecontroller = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers = [];

  Future<void> pickAndScanImage() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      backgroundColor: kSecandryColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a photo"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleImage(ImageSource.camera, picker);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleImage(ImageSource.gallery, picker);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _handleImage(ImageSource source, ImagePicker picker) async {
    final image = await picker.pickImage(source: source);
    if (image == null) return;
    isLoading.value = true;

    final inputImage = InputImage.fromFile(File(image.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText result = await textRecognizer.processImage(inputImage);

    final List<String> scannedLines = [];
    for (final block in result.blocks) {
      for (final line in block.lines) {
        scannedLines.add(line.text.toLowerCase().trim());
      }
    }
    scannedText.value = scannedLines;

    controllers =
        scannedLines.map((text) => TextEditingController(text: text)).toList();

    isLoading.value = false;

    textRecognizer.close();
  }

  void collectFromText() {
    final List<String> products =
        medicinecontroller.text
            .split(',')
            .map((word) => word.toLowerCase().trim())
            .where((word) => word.isNotEmpty)
            .toList();
    scannedText.value = [...scannedText, ...products];
    controllers.addAll(
      products.map((text) => TextEditingController(text: text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      backgroundColor: kPrimarybgColor,
      appBar: AppBar(
        title: const Text(
          "Scan & Search",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.black,
        onPressed: pickAndScanImage,
        label: const Text("Scan"),
        icon: const Icon(Icons.document_scanner),
        backgroundColor: kPrimaryColor,
      ),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(20),
          child:
              isLoading.value
                  ? const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  )
                  : SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  overflow:
                                      TextOverflow
                                          .ellipsis, // Add this line to truncate with "..."
                                  maxLines: 1,
                                  '${widget.placemark.street!}-${widget.placemark.administrativeArea} ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.location_on,
                                size: 25,
                                color: kPrimaryColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kSecandryColor,
                              borderRadius: BorderRadius.circular(12),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(8, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Scanned Text",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    IconButton(
                                      onPressed: () {
                                        scannedText.clear();
                                      },
                                      icon: Icon(
                                        Icons.delete_sweep_sharp,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 300,
                                  child: SingleChildScrollView(
                                    child: Obx(
                                      () =>
                                          scannedText.isNotEmpty
                                              ? Column(
                                                children: List.generate(scannedText.length, (
                                                  index,
                                                ) {
                                                  final controller =
                                                      controllers[index];

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          bottom: 10,
                                                        ),
                                                    child: TextFormField(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      textAlign: TextAlign.left,
                                                      controller: controller,
                                                      onChanged: (val) {
                                                        scannedText[index] =
                                                            val
                                                                .toLowerCase()
                                                                .trim();
                                                      },
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            "Scanned line ${index + 1}",
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        kPrimaryColor,
                                                                  ),
                                                            ),
                                                        suffixIcon: IconButton(
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                          onPressed: () {
                                                            scannedText
                                                                .removeAt(
                                                                  index,
                                                                );
                                                            controllers
                                                                .removeAt(
                                                                  index,
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              )
                                              : const Text(
                                                "No text scanned yet.",
                                              ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'field is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              labelText: 'Distance Range ?',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                            ),
                            controller: rangecontroller,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              labelText: 'medicine separated by comma',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(CupertinoIcons.text_insert),
                                onPressed: collectFromText,
                              ),
                            ),
                            controller: medicinecontroller,
                          ),
                          SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: kPrimaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.send),
                              label: const Text("Submit"),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => PharmaciesScreen(
                                            range: rangecontroller.text,
                                            medicine: scannedText.toList(),
                                            lat: widget.lat,
                                            long: widget.long,
                                          ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
