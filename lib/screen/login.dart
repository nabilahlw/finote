import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/data/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key}) {
    // Register controller di constructor
    Get.put(SignController());
  }

  final RxBool isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FINANCE APP', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xff5E4392),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) => v == null || v.isEmpty ? 'Username wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !GetUtils.isEmail(v) ? 'Email tidak valid' : null,
              ),
              const SizedBox(height: 16),
              Obx(() => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !isPasswordVisible.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          isPasswordVisible.toggle();
                        },
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6 ? 'Min. 6 karakter' : null,
                  )),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFA993B),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  )),
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.signUp,
                child: const Text('Sign Up', style: TextStyle(color: Color(0xff5E4392))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}