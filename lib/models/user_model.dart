class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'phone': phone, 'email': email};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
    );
  }
}
