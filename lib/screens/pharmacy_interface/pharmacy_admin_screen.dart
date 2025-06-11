import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mediscan/consts.dart';
import 'package:mediscan/models/pharmacy_model.dart';

class PharmacyAdminScreen extends StatefulWidget {
  const PharmacyAdminScreen({super.key, required this.pharmacyModel});
  final PharmacyModel pharmacyModel;

  @override
  State<PharmacyAdminScreen> createState() => _PharmacyAdminScreenState();
}

class _PharmacyAdminScreenState extends State<PharmacyAdminScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late final CollectionReference productsRef;

  @override
  void initState() {
    super.initState();
    productsRef = FirebaseFirestore.instance
        .collection('pharmacies')
        .doc(uid)
        .collection('products');
  }

  Future<void> addMedicine(String name, double price, int quantity) async {
    await productsRef.doc(name.toLowerCase()).set({
      'name': name,
      'price': price,
      'quantity': quantity,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name added successfully')));
  }

  Future<void> updateMedicine(String name, double price, int quantity) async {
    await productsRef.doc(name.toLowerCase()).update({
      'price': price,
      'quantity': quantity,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name updated successfully')));
  }

  Future<void> deleteMedicine(String name) async {
    await productsRef.doc(name.toLowerCase()).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$name deleted successfully')));
  }

  void showAddMedicineDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Medicine",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: "Price",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                    onPressed: () {
                      final name = nameController.text.trim();
                      final price = double.tryParse(priceController.text);
                      final quantity = int.tryParse(quantityController.text);

                      if (name.isEmpty || price == null || quantity == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter valid data')),
                        );
                        return;
                      }

                      Navigator.pop(context);
                      addMedicine(name, price, quantity);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void showUpdateMedicineDialog(
    String name,
    double currentPrice,
    int currentQuantity,
  ) {
    final priceController = TextEditingController(
      text: currentPrice.toString(),
    );
    final quantityController = TextEditingController(
      text: currentQuantity.toString(),
    );

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Update Medicine"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: "Quantity"),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final price = double.tryParse(priceController.text);
                  final quantity = int.tryParse(quantityController.text);

                  if (price == null || quantity == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter valid price and quantity'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  updateMedicine(name, price, quantity);
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimarybgColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Pharmacy Admin',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 28),
            onPressed: showAddMedicineDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Card(
              color: kSecandryColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 📷 Pharmacy Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.pharmacyModel.image,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 📄 Pharmacy Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🏪 Name
                          Text(
                            widget.pharmacyModel.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 📍 Address + Location
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.pharmacyModel.address,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 24,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // ☎️ Phone + Call
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.pharmacyModel.phone,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.call,
                                color: Colors.green,
                                size: 24,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: productsRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final medicines = snapshot.data!.docs;

                  if (medicines.isEmpty) {
                    return const Center(child: Text("No medicines found."));
                  }

                  return ListView.builder(
                    itemCount: medicines.length,
                    itemBuilder: (_, index) {
                      final data =
                          medicines[index].data() as Map<String, dynamic>;
                      final name = data['name'];
                      final price = data['price']?.toDouble() ?? 0.0;
                      final quantity = data['quantity']?.toInt() ?? 0;

                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          title: Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Price: \$${price.toStringAsFixed(2)}   •   Qty: $quantity',
                          ),
                          trailing: Wrap(
                            spacing: 12,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed:
                                    () => showUpdateMedicineDialog(
                                      name,
                                      price,
                                      quantity,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => deleteMedicine(name),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
