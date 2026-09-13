import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/budget_service.dart';
import 'add_expense_screen.dart';
import 'budget_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ==========================================================
  // Filter
  // ==========================================================

  String _selectedFilter = 'All';

  String _selectedCategory = 'Food';

  final List<String> _filters = [
    'All',
    'Today',
    'This Week',
    'This Month',
    'By Category',
  ];

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Other',
  ];

  // ==========================================================
  // Build
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final ExpenseService expenseService =
        Provider.of<ExpenseService>(context);

    final BudgetService budgetService =
        Provider.of<BudgetService>(context);

    final List<Expense> filteredExpenses =
        expenseService.getFilteredExpenses(
      filter: _selectedFilter,
      category: _selectedCategory,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Budget',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BudgetScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.account_balance_wallet_outlined,
            ),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // Currently data is stored in memory.
          // This will be useful later when we add database storage.
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // Budget Card
              // ==================================================

              _buildBudgetCard(budgetService),

              const SizedBox(height: 24),

              // ==================================================
              // Summary
              // ==================================================

              const Text(
                'Expense Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildSummaryGrid(expenseService),

              const SizedBox(height: 24),

              // ==================================================
              // Category Summary
              // ==================================================

              const Text(
                'Category Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildCategorySummary(expenseService),

              const SizedBox(height: 24),

              // ==================================================
              // Expense List
              // ==================================================

              const Text(
                'Expenses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _buildFilter(),

              const SizedBox(height: 16),

              if (_selectedFilter == 'By Category')
                _buildCategoryFilter(),

              if (_selectedFilter == 'By Category')
                const SizedBox(height: 16),

              _buildExpenseList(
                expenseService,
                filteredExpenses,
              ),
            ],
          ),
        ),
      ),

      // ========================================================
      // Add Expense
      // ========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AddExpenseScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  // ==========================================================
  // Budget Card
  // ==========================================================

  Widget _buildBudgetCard(
    BudgetService budgetService,
  ) {
    final double budget = budgetService.monthlyBudget;

    final double spent =
        context.read<ExpenseService>().getThisMonthExpenses().fold(
              0.0,
              (sum, expense) => sum + expense.amount,
            );

    final double remaining = budget - spent;

    final double percentage =
        budget > 0 ? (spent / budget) * 100 : 0;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 28,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    'Monthly Budget',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BudgetScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              'Budget: ৳${budget.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Spent: ৳${spent.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              remaining >= 0
                  ? 'Remaining: ৳${remaining.toStringAsFixed(2)}'
                  : 'Over Budget: ৳${remaining.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: remaining >= 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 14),

            if (budget > 0) ...[
              LinearProgressIndicator(
                value: (percentage / 100).clamp(0.0, 1.0),
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Spending',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              _buildSpendingStatus(
                percentage,
              ),
            ] else
              const Text(
                'No monthly budget set.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
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

  Widget _buildSpendingStatus(double percentage) {
    String status;

    if (percentage < 50) {
      status = 'Safe';
    } else if (percentage < 80) {
      status = 'Moderate';
    } else if (percentage <= 100) {
      status = 'Warning';
    } else {
      status = 'Over Budget';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Status: $status',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // Summary Grid
  // ==========================================================

  Widget _buildSummaryGrid(
    ExpenseService service,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.45,
      children: [

        _buildSummaryCard(
          title: 'Total Expense',
          value: service.totalExpense,
          icon: Icons.payments_outlined,
        ),

        _buildSummaryCard(
          title: "Today's Expense",
          value: service.todayExpense,
          icon: Icons.today,
        ),

        _buildSummaryCard(
          title: 'Highest Expense',
          value: service.highestExpense,
          icon: Icons.arrow_upward,
        ),

        _buildSummaryCard(
          title: 'Lowest Expense',
          value: service.lowestExpense,
          icon: Icons.arrow_downward,
        ),

        _buildSummaryCard(
          title: 'Average Expense',
          value: service.averageExpense,
          icon: Icons.calculate_outlined,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            Icon(icon, size: 25),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '৳${value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // Category Summary
  // ==========================================================

  Widget _buildCategorySummary(
    ExpenseService service,
  ) {
    return Column(
      children: [

        _buildCategoryTile(
          'Food',
          service.foodTotal,
          Icons.restaurant,
        ),

        _buildCategoryTile(
          'Transport',
          service.transportTotal,
          Icons.directions_bus,
        ),

        _buildCategoryTile(
          'Shopping',
          service.shoppingTotal,
          Icons.shopping_cart,
        ),

        _buildCategoryTile(
          'Other',
          service.otherTotal,
          Icons.more_horiz,
        ),
      ],
    );
  }

  Widget _buildCategoryTile(
    String category,
    double amount,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(category),
        trailing: Text(
          '৳${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Filter
  // ==========================================================

  Widget _buildFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedFilter,
      decoration: const InputDecoration(
        labelText: 'Filter Expenses',
        prefixIcon: Icon(Icons.filter_list),
        border: OutlineInputBorder(),
      ),
      items: _filters.map((filter) {
        return DropdownMenuItem(
          value: filter,
          child: Text(filter),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }

  // ==========================================================
  // Category Filter
  // ==========================================================

  Widget _buildCategoryFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Select Category',
        prefixIcon: Icon(Icons.category_outlined),
        border: OutlineInputBorder(),
      ),
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  // ==========================================================
  // Expense List
  // ==========================================================

  Widget _buildExpenseList(
    ExpenseService service,
    List<Expense> expenses,
  ) {
    if (expenses.isEmpty) {
      return _buildEmptyExpenseView();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final Expense expense = expenses[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),

            leading: CircleAvatar(
              child: Icon(
                _getCategoryIcon(
                  expense.category,
                ),
              ),
            ),

            title: Text(
              expense.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            subtitle: Text(
              '${expense.category} • ${_formatDate(expense.date)}',
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  '৳${expense.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  tooltip: 'Delete',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _confirmDelete(
                      context,
                      service,
                      expense.id,
                      expense.title,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================
  // Empty Expense View
  // ==========================================================

  Widget _buildEmptyExpenseView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 20,
        ),
        child: Center(
          child: Column(
            children: const [
              Icon(
                Icons.receipt_long,
                size: 60,
              ),

              SizedBox(height: 15),

              Text(
                'No expenses found.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Try another filter or add a new expense.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Delete Confirmation
  // ==========================================================

  Future<void> _confirmDelete(
    BuildContext context,
    ExpenseService service,
    String id,
    String title,
  ) async {
    final bool? confirmed =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Expense?',
          ),
          content: Text(
            'Are you sure you want to delete "$title"?',
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      service.deleteExpense(id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Expense deleted successfully.',
          ),
        ),
      );
    }
  }

  // ==========================================================
  // Category Icon
  // ==========================================================

  IconData _getCategoryIcon(
    String category,
  ) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;

      case 'Transport':
        return Icons.directions_bus;

      case 'Shopping':
        return Icons.shopping_cart;

      case 'Other':
        return Icons.more_horiz;

      default:
        return Icons.receipt_long;
    }
  }

  // ==========================================================
  // Date Format
  // ==========================================================

  String _formatDate(DateTime date) {
    final String day =
        date.day.toString().padLeft(2, '0');

    final String month =
        date.month.toString().padLeft(2, '0');

    final String year =
        date.year.toString();

    return '$day/$month/$year';
  }
}