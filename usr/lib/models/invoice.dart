import 'patient.dart';
import 'service_item.dart';

class Invoice {
  final String id;
  final Patient patient;
  final List<ServiceItem> services;
  final double discount;
  final double taxRate;
  final bool isPaid;

  Invoice({
    required this.id,
    required this.patient,
    required this.services,
    this.discount = 0.0,
    this.taxRate = 0.0,
    this.isPaid = false,
  });

  double get subtotal => services.fold(0, (sum, item) => sum + item.price);
  double get taxAmount => subtotal * taxRate;
  double get total => subtotal + taxAmount - discount;
}
