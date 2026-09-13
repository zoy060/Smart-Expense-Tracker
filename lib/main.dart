import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/expense_service.dart';
import 'services/budget_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseService(),
        ),

        ChangeNotifierProvider(
          create: (_) => BudgetService(),
        ),
      ],
      child: const SmartExpenseTrackerApp(),
    ),
  );
}

class SmartExpenseTrackerApp
    extends StatelessWidget {
  const SmartExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Smart Expense Tracker',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}