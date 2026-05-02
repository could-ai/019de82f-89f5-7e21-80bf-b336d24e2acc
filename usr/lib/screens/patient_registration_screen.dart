import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/mock_database.dart';

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime? _selectedDob;

  final MockDatabase _db = MockDatabase();

  void _registerPatient() {
    if (_formKey.currentState!.validate() && _selectedDob != null) {
      final nic = _nicController.text.trim();
      final contact = _contactController.text.trim();

      // Duplicate check
      final existingPatient = _db.patients.where((p) => p.nic == nic || p.contactNumber == contact).firstOrNull;

      if (existingPatient != null) {
        _showDialog(
          title: 'Duplicate Found',
          content: 'A patient with this NIC or Contact Number already exists.\n\nName: ${existingPatient.name}\nPatient ID: ${existingPatient.id}',
        );
      } else {
        // Create new
        final newPatient = Patient(
          id: _db.generatePatientId(),
          name: _nameController.text.trim(),
          dob: _selectedDob!,
          contactNumber: contact,
          nic: nic,
        );

        setState(() {
          _db.patients.add(newPatient);
        });

        _showDialog(
          title: 'Registration Successful',
          content: 'Patient successfully registered!\n\nPatient ID: ${newPatient.id}',
          onOk: () {
            _nameController.clear();
            _nicController.clear();
            _contactController.clear();
            setState(() {
              _selectedDob = null;
            });
          }
        );
      }
    } else if (_selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Date of Birth')),
      );
    }
  }

  void _showDialog({required String title, required String content, VoidCallback? onOk}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (onOk != null) onOk();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDob(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)), // Default ~20 years old
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Patient'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nicController,
                decoration: const InputDecoration(
                  labelText: 'NIC / Passport',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter NIC or Passport' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? 'Please enter contact number' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDob(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDob == null
                        ? 'Select DOB'
                        : '\${_selectedDob!.toLocal()}'.split(' ')[0],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _registerPatient,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Register Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
