import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/data/auth_repo.dart';
import 'package:myapp/data/user_repo.dart';
import 'package:myapp/data/model/user_model.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/widget/bottomnavigationbar.dart';

class SignController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final userRepo = Get.put(UserRepository());
  final dataService = Get.find<FirebaseDataService>();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User tidak ditemukan');
      final userDoc = await userRepo.getUserDetails(uid);
      await dataService.saveUserName(userDoc.username);

      Get.snackbar('Sukses', 'Login berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(() => Bottom(dataService: dataService));
    } catch (e) {
      Get.snackbar(
        'Login Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await AuthenticationRepository.instance.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      final user = UserModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await userRepo.createUser(user);
      await dataService.saveUserName(user.username);

      Get.snackbar('Sukses', 'Akun berhasil dibuat!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(() => Bottom(dataService: dataService));
    } catch (e) {
      Get.snackbar(
        'Sign Up Gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
