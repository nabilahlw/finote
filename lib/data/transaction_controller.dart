import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/model/add_model.dart';
import '../data/add_repo.dart';

class TransactionController extends GetxController {
  final repo = Get.put(FormMoneyRepository());
  final rxList = <AddData>[].obs;
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  var selectedCategory = ''.obs;
  var amount = ''.obs;
  var description = ''.obs;
  var datetime = DateTime.now().obs;
  var selectedType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    repo.streamTransactions().listen((list) {
      rxList.value = list;
    });
  }

  Future<void> createTransaction(AddData item) async {
    isLoading.value = true;
    await repo.addTransaction(item);
    isLoading.value = false;
  }

  Future<void> updateTransaction(AddData item) async {
    isLoading.value = true;
    await repo.updateTransaction(item);
    isLoading.value = false;
  }

  Future<void> deleteTransaction(String id) async {
    isLoading.value = true;
    await repo.deleteTransaction(id);
    isLoading.value = false;
  }
}
