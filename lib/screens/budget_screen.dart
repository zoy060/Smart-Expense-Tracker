import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/budget_service.dart';
import '../services/expense_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() =>
      _BudgetScreenState();
}

class _BudgetScreenState
    extends State<BudgetScreen> {

  // ==========================================================
  // Controller
  // ==========================================================

  final TextEditingController _budgetController =
      TextEditingController();

  // ==========================================================
  // Form
  // ==========================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // ==========================================================
  // Dispose
  // ==========================================================

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  // ==========================================================
  // Build
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final BudgetService budgetService =
        context.watch<BudgetService>();

    final ExpenseService expenseService =
        context.watch<ExpenseService>();

    final double budget =
        budgetService.monthlyBudget;

    final double spent =
        _getCurrentMonthExpense(
      expenseService,
    );

    final double remaining =
        budget - spent;

    final double percentage =
        budget > 0
            ? (spent / budget) * 100
            : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monthly Budget',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // ==================================================
              // Header
              // ==================================================

              const Text(
                'Set Your Monthly Budget',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Set a spending limit for the current month.',
              ),

              const SizedBox(height: 25),

              // ==================================================
              // Budget Input
              // ==================================================

              TextFormField(
                controller: _budgetController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration:
                    const InputDecoration(
                  labelText: 'Monthly Budget',
                  hintText: 'Example: 20000',
                  prefixIcon: Icon(
                    Icons.account_balance_wallet,
                  ),
                  prefixText: '৳ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your budget';
                  }

                  final double? amount =
                      double.tryParse(
                    value.trim(),
                  );

                  if (amount == null) {
                    return 'Please enter a valid number';
                  }

                  if (amount < 0) {
                    return 'Budget cannot be negative';
                  }

                  if (amount == 0) {
                    return 'Budget must be greater than 0';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // ==================================================
              // Save Budget
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _saveBudget();
                  },
                  icon: const Icon(
                    Icons.save,
                  ),
                  label: const Text(
                    'Save Budget',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // Current Budget
              // ==================================================

              const Text(
                'Budget Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildOverviewCard(
                title: 'Monthly Budget',
                value: budget,
                icon: Icons.account_balance_wallet,
              ),

              _buildOverviewCard(
                title: 'This Month Spent',
                value: spent,
                icon: Icons.payments,
              ),

              _buildOverviewCard(
                title: remaining >= 0
                    ? 'Remaining Budget'
                    : 'Over Budget',
                value: remaining.abs(),
                icon: remaining >= 0
                    ? Icons.savings
                    : Icons.warning,
                valueColor: remaining >= 0
                    ? Colors.green
                    : Colors.red,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // Progress
              // ==================================================

              if (budget > 0)
                _buildProgressSection(
                  percentage,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Save Budget
  // ==========================================================

  void _saveBudget() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double? budget =
        double.tryParse(
      _budgetController.text.trim(),
    );

    if (budget == null || budget <= 0) {
      return;
    }

    final BudgetService service =
        context.read<BudgetService>();

    service.setMonthlyBudget(budget);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Monthly budget saved successfully.',
        ),
      ),
    );
  }

  // ==========================================================
  // Current Month Expense
  // ==========================================================

  double _getCurrentMonthExpense(
    ExpenseService service,
  ) {
    final expenses =
        service.getThisMonthExpenses();

    double total = 0;

    for (final expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  // ==========================================================
  // Overview Card
  // ==========================================================

  Widget _buildOverviewCard({
    required String title,
    required double value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        trailing: Text(
          '৳${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Progress Section
  // ==========================================================

  Widget _buildProgressSection(
    double percentage,
  ) {
    final String status =
        _getSpendingStatus(percentage);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              'Spending Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            LinearProgressIndicator(
              value: (percentage / 100)
                  .clamp(0.0, 1.0),
              minHeight: 10,
              borderRadius:
                  BorderRadius.circular(10),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        _getStatusColor(
                      percentage,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              _getStatusMessage(
                percentage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // Spending Status
  // ==========================================================

  String _getSpendingStatus(
    double percentage,
  ) {
    if (percentage < 50) {
      return 'Safe';
    }

    if (percentage < 80) {
      return 'Moderate';
    }

    if (percentage <= 100) {
      return 'Warning';
    }

    return 'Over Budget';
  }

  // ==========================================================
  // Status Color
  // ==========================================================

  Color _getStatusColor(
    double percentage,
  ) {
    if (percentage < 50) {
      return Colors.green;
    }

    if (percentage < 80) {
      return Colors.orange;
    }

    if (percentage <= 100) {
      return Colors.deepOrange;
    }

    return Colors.red;
  }

  // ==========================================================
  // Status Message
  // ==========================================================

  String _getStatusMessage(
    double percentage,
  ) {
    if (percentage < 50) {
      return 'Your spending is below 50% of your monthly budget. Good job!';
    }

    if (percentage < 80) {
      return 'Your spending is moderate. Keep monitoring your expenses.';
    }

    if (percentage <= 100) {
      return 'You are approaching your monthly budget limit.';
    }

    return 'Your expenses have exceeded your monthly budget.';
  }
}