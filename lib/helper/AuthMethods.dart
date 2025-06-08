import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediscan/models/user_model.dart';

class Authmethods {
  Future<UserCredential> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    UserModel user = UserModel(
      uid: uid,
      name: name,
      phone: phone,
      email: email,
    );

    await firestore.collection('users').doc(uid).set(user.toMap());
    return credential;
  }

  Future<UserModel> fetchUserData(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    } else {
      throw Exception("User data not found");
    }
  }

  Future<UserModel> loginUser(String email, String password) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    return await fetchUserData(uid);
  }
}
