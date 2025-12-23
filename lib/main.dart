import 'package:flutter/material.dart';

// ✅ New dashboard entry (Step 3)
import 'features/dashboard/src/presentation/pages/dashboard_page.dart';

void main() {
  runApp(const MoneyKeeperApp());
}

class MoneyKeeperApp extends StatelessWidget {
  const MoneyKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MoneyKeeper',
      debugShowCheckedModeBanner: false,

      // ✅ Go straight to the new Dashboard UI (no bootstrap)
      home: DashboardPage(),
    );
  }
}
