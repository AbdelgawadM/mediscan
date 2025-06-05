class MedicineModel {
  final String name;
  final double price;
  final int quantity;

  const MedicineModel({
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {'name': name.toLowerCase(), 'price': price, 'quantity': quantity};
  }

  factory MedicineModel.fromMap(Map<String, dynamic> map) {
    return MedicineModel(
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}
