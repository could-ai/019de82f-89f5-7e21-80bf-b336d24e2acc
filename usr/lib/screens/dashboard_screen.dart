import 'package:flutter/material.dart';
import 'patient_registration_screen.dart';
import 'billing_screen.dart';
import '../services/mock_database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PatientRegistrationScreen(),
    const BillingScreen(),
    const AuditLogScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person_add),
                label: Text('Registration'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt),
                label: Text('Billing'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_alt),
                label: Text('Audit/Ledger'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class AuditLogScreen extends StatelessWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = MockDatabase();
    return Scaffold(
      appBar: AppBar(title: const Text('Audit Log & Ledger')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Registered Patients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: db.patients.length,
                itemBuilder: (ctx, i) {
                  final p = db.patients[i];
                  return ListTile(
                    title: Text(p.name),
                    subtitle: Text('ID: \${p.id} | NIC: \${p.nic}'),
                  );
                },
              ),
            ),
            const Divider(),
            const Text('Invoices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: db.invoices.length,
                itemBuilder: (ctx, i) {
                  final inv = db.invoices[i];
                  return ListTile(
                    title: Text('Invoice \${inv.id} - \${inv.patient.name}'),
                    subtitle: Text('Total: \$\${inv.total.toStringAsFixed(2)} | Services: \${inv.services.length}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
