import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/screen/home.dart';
import 'package:myapp/screen/login.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rxn<User?> firebaseUser;
  User? get currentUser => _auth.currentUser;


  @override
  void onReady() {
    super.onReady();
    // Menggunakan onReady untuk memastikan GetMaterialApp sudah siap
    firebaseUser = Rxn<User>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      final dataService = Get.find<FirebaseDataService>();
      Get.offAll(() => Home(dataService: dataService));
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
  try {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  }
}

Future<void> loginWithEmailAndPassword(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  }
}

Future<void> signOut() async {
  try {
    await _auth.signOut();
  } catch (e) {
    throw Exception(e.toString());
  }
}

}

// ... (class SignUpWithEmailAndPasswordFailure dan LoginWithEmailAndPasswordFailure tetap sama)