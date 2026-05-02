import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/service_item.dart';
import '../models/invoice.dart';
import '../services/mock_database.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final MockDatabase _db = MockDatabase();
  
  Patient? _selectedPatient;
  final List<ServiceItem> _selectedServices = [];
  double _discount = 0.0;
  final double _taxRate = 0.1; // 10% tax for example
  
  final TextEditingController _discountController = TextEditingController();

  double get _subtotal => _selectedServices.fold(0, (sum, item) => sum + item.price);
  double get _taxAmount => _subtotal * _taxRate;
  double get _total => _subtotal + _taxAmount - _discount;

  void _addService(ServiceItem service) {
    setState(() {
      _selectedServices.add(service);
    });
  }

  void _removeService(ServiceItem service) {
    setState(() {
      _selectedServices.remove(service);
    });
  }

  void _processPayment() {
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient first.')),
      );
      return;
    }
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one service.')),
      );
      return;
    }

    final invoice = Invoice(
      id: _db.generateInvoiceId(),
      patient: _selectedPatient!,
      services: List.from(_selectedServices),
      discount: _discount,
      taxRate: _taxRate,
      isPaid: true,
    );

    setState(() {
      _db.invoices.add(invoice);
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text('Receipt generated.\n\nInvoice ID: \${invoice.id}\nTotal Paid: \$\${invoice.total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _selectedPatient = null;
      _selectedServices.clear();
      _discountController.clear();
      _discount = 0.0;
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
      ),
      body: Row(
        children: [
          // Left side - Patient & Invoice Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Select Patient', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<Patient>(
                    value: _selectedPatient,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    hint: const Text('Choose a Patient'),
                    items: _db.patients.map((p) {
                      return DropdownMenuItem<Patient>(
                        value: p,
                        child: Text('\${p.name} (\${p.nic})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedPatient = val;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Invoice Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _selectedServices.length,
                      itemBuilder: (context, index) {
                        final service = _selectedServices[index];
                        return ListTile(
                          title: Text(service.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('\$\${service.price.toStringAsFixed(2)}'),
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () => _removeService(service),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: _discountController,
                    decoration: const InputDecoration(labelText: 'Discount (\$)'),
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      setState(() {
                        _discount = double.tryParse(val) ?? 0.0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Subtotal: \$\${_subtotal.toStringAsFixed(2)}'),
                  Text('Tax (10%): \$\${_taxAmount.toStringAsFixed(2)}'),
                  Text('Discount: -\$\${_discount.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Text('Total: \$\${_total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _processPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Process Payment', style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Right side - Available Services
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Available Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _db.availableServices.length,
                      itemBuilder: (context, index) {
                        final service = _db.availableServices[index];
                        return Card(
                          child: ListTile(
                            title: Text(service.description),
                            subtitle: Text('\$\${service.price.toStringAsFixed(2)}'),
                            trailing: const Icon(Icons.add_circle, color: Colors.blue),
                            onTap: () => _addService(service),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
