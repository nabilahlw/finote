import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'package:myapp/firebase_options.dart'; // ⬅️ Tambahkan ini!
import 'package:myapp/data/auth_repo.dart';
import 'package:myapp/data/data_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Pakai FirebaseOptions dari firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  

  // ✅ Register GetX Services
  Get.put(AuthenticationRepository());
  Get.put(FirebaseDataService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = Get.find<AuthenticationRepository>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        final user = authRepo.firebaseUser.value;
        if (user == null && authRepo.currentUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const SizedBox(); // akan diganti oleh Get.offAll()
        }
      }),
    );
  }
}
