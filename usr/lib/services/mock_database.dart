import '../models/patient.dart';
import '../models/invoice.dart';
import '../models/service_item.dart';

class MockDatabase {
  static final MockDatabase _instance = MockDatabase._internal();

  factory MockDatabase() {
    return _instance;
  }

  MockDatabase._internal();

  List<Patient> patients = [];
  List<Invoice> invoices = [];
  
  List<ServiceItem> availableServices = [
    ServiceItem(id: 'S1', description: 'Consultation', price: 50.0),
    ServiceItem(id: 'S2', description: 'Blood Test', price: 20.0),
    ServiceItem(id: 'S3', description: 'X-Ray', price: 100.0),
    ServiceItem(id: 'S4', description: 'Vaccination', price: 30.0),
  ];

  String generatePatientId() {
    return 'P${(patients.length + 1).toString().padLeft(4, '0')}';
  }

  String generateInvoiceId() {
    return 'INV${(invoices.length + 1).toString().padLeft(4, '0')}';
  }
}
