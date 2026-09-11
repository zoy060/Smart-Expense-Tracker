import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Temporary values.
  // Later these will come from ExpenseService.
  double totalExpense = 0.0;
  double todayExpense = 0.0;
  double highestExpense = 0.0;
  double lowestExpense = 0.0;
  double averageExpense = 0.0;

  double monthlyBudget = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------------------------------------
            // Budget Section
            // ------------------------------------------------
            _buildBudgetCard(),

            const SizedBox(height: 20),

            // ------------------------------------------------
            // Expense Summary
            // ------------------------------------------------
            const Text(
              'Expense Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildSummaryGrid(),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // Category Summary
            // ------------------------------------------------
            const Text(
              'Category Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildCategorySummary(),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // Filter
            // ------------------------------------------------
            const Text(
              'Expenses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildFilterDropdown(),

            const SizedBox(height: 16),

            // ------------------------------------------------
            // Empty Expense View
            // ------------------------------------------------
            _buildEmptyExpenseView(),
          ],
        ),
      ),

      // ------------------------------------------------
      // Add Expense Button
      // ------------------------------------------------
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // We will navigate to AddExpenseScreen later.
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
    );
  }

  // ========================================================
  // Budget Card
  // ========================================================

  Widget _buildBudgetCard() {
    double remainingBudget = monthlyBudget - totalExpense;

    return Card(
      elevation: 2,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    // Budget screen will be connected later.
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Budget: ৳${monthlyBudget.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Remaining: ৳${remainingBudget.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: remainingBudget < 0
                    ? Colors.red
                    : Colors.green,
              ),
            ),

            const SizedBox(height: 12),

            _buildSpendingStatus(),
          ],
        ),
      ),
    );
  }

  // ========================================================
  // Expense Summary Grid
  // ========================================================

  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [

        _buildSummaryCard(
          title: 'Total Expense',
          value: totalExpense,
          icon: Icons.payments,
        ),

        _buildSummaryCard(
          title: "Today's Expense",
          value: todayExpense,
          icon: Icons.today,
        ),

        _buildSummaryCard(
          title: 'Highest Expense',
          value: highestExpense,
          icon: Icons.arrow_upward,
        ),

        _buildSummaryCard(
          title: 'Lowest Expense',
          value: lowestExpense,
          icon: Icons.arrow_downward,
        ),

        _buildSummaryCard(
          title: 'Average Expense',
          value: averageExpense,
          icon: Icons.calculate,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(icon, size: 25),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '৳${value.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========================================================
  // Category Summary
  // ========================================================

  Widget _buildCategorySummary() {
    return Column(
      children: [
        _buildCategoryTile(
          'Food',
          0.0,
          Icons.restaurant,
        ),

        _buildCategoryTile(
          'Transport',
          0.0,
          Icons.directions_bus,
        ),

        _buildCategoryTile(
          'Shopping',
          0.0,
          Icons.shopping_cart,
        ),

        _buildCategoryTile(
          'Other',
          0.0,
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

  // ========================================================
  // Filter Dropdown
  // ========================================================

  Widget _buildFilterDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: 'All',
      decoration: const InputDecoration(
        labelText: 'Filter Expenses',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.filter_list),
      ),
      items: const [
        DropdownMenuItem(
          value: 'All',
          child: Text('All'),
        ),
        DropdownMenuItem(
          value: 'Today',
          child: Text('Today'),
        ),
        DropdownMenuItem(
          value: 'This Week',
          child: Text('This Week'),
        ),
        DropdownMenuItem(
          value: 'This Month',
          child: Text('This Month'),
        ),
        DropdownMenuItem(
          value: 'By Category',
          child: Text('By Category'),
        ),
      ],
      onChanged: (value) {
        // Filter logic will be added later.
      },
    );
  }

  // ========================================================
  // Spending Status
  // ========================================================

  Widget _buildSpendingStatus() {
    if (monthlyBudget <= 0) {
      return const Text(
        'Set a budget to see spending status.',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      );
    }

    double percentage = totalExpense / monthlyBudget * 100;

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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Spending Status: $status',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
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
    );
  }

  // ========================================================
  // Empty Expense View
  // ========================================================

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
                'No expenses added yet.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                'Tap the Add Expense button to add your first expense.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}