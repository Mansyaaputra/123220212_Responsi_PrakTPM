import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ApiService _apiService = ApiService();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final phone = Phone(
        id: 0,
        name: _nameController.text,
        brand: _brandController.text,
        price: int.tryParse(_priceController.text) ?? 0,
        img_url: '',
        specification: _descriptionController.text,
      );
      await _apiService.addPhone(phone);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Phone'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 27, 127, 226),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Add New Phone',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 27, 127, 226),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.phone_android,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _brandController,
                    label: 'Brand',
                    icon: Icons.branding_watermark,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _priceController,
                    label: 'Price',
                    icon: Icons.price_check,
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Spesification',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text('Add Phone'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 27, 127, 226),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }
}
