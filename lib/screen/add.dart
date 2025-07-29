import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/data/data_services.dart';
import 'package:myapp/data/model/add_model.dart';
import '../data/transaction_controller.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  final FirebaseDataService dataService;
  final AddData? editData;
  final void Function(AddData) onSave;

  const AddScreen({
    super.key,
    required this.dataService,
    this.editData,
    required this.onSave,
  });

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final TransactionController controller = Get.put(TransactionController());

  final List<String> categories = [
    'Foods', 'Travel', 'Groceries', 'Freelance', 'Salary', 'Gift', 'Health', 'Education', 'Shopping', 'Bills', 'Others',
  ];
  final List<String> types = ['Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    if (widget.editData != null) {
      controller.selectedCategory.value = widget.editData!.name;
      controller.amount.value = widget.editData!.amount.toString();
      controller.description.value = widget.editData!.description;
      controller.datetime.value = widget.editData!.datetime;
      
      // PERBAIKAN: Mengubah tipe dari int menjadi string untuk dropdown
      // ignore: unrelated_type_equality_checks
      controller.selectedType.value = widget.editData!.type == 1 ? 'Income' : 'Expense';
    }
  }

  void _submit() async {
  if (controller.formKey.currentState!.validate()) {
    final AddData data = AddData(
      name: controller.selectedCategory.value,
      amount: double.parse(controller.amount.value),
      description: controller.description.value,
      datetime: controller.datetime.value,
      type: controller.selectedType.value == 'Income' ? 1 : 0,
      category: controller.selectedCategory.value,
    );

    if (widget.editData == null) {
      await widget.dataService.addData(data);
    } else {
      await widget.dataService.updateData(widget.editData!.id!, data);
    }

    widget.onSave(data);
    Get.back(); // Kembali ke home dan home akan auto refresh lewat StreamBuilder
  }
}



  @override
  Widget build(BuildContext context) {
    final formKey = controller.formKey;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff5E4392),
        title: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedCategory.value.isNotEmpty ? controller.selectedCategory.value : null,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => controller.selectedCategory.value = v!,
              validator: (v) => v == null || v.isEmpty ? 'Pilih kategori' : null,
            )),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(text: controller.amount.value),
              decoration: const InputDecoration(labelText: 'Amount (Rp)'),
              keyboardType: TextInputType.number,
              onChanged: (v) => controller.amount.value = v,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: TextEditingController(text: controller.description.value),
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (v) => controller.description.value = v,
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            // PERBAIKAN: Menambahkan Obx untuk mengamati perubahan
            Obx(() => Text('Date: ${DateFormat('yyyy-MM-dd').format(controller.datetime.value.toLocal())}')),
            TextButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.datetime.value,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2099),
                );
                if (picked != null) {
                  controller.datetime.value = picked;
                }
              },
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedType.value.isNotEmpty ? controller.selectedType.value : null,
              decoration: const InputDecoration(labelText: 'Income / Expense'),
              items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => controller.selectedType.value = v!,
              validator: (v) => v == null ? 'Pilih tipe' : null,
            )),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff5E4392), padding: const EdgeInsets.symmetric(vertical: 15)),
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}