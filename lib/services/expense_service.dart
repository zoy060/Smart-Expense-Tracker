import 'package:flutter/foundation.dart';

import '../models/expense.dart';

class ExpenseService extends ChangeNotifier {
  // ==========================================================
  // Expense List
  // ==========================================================

  final List<Expense> _expenses = [];

  // Read-only access to expenses.
  List<Expense> get expenses => List.unmodifiable(_expenses);

  // ==========================================================
  // Add Expense
  // ==========================================================

  bool addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
  }) {
    // Title validation
    if (title.trim().isEmpty) {
      return false;
    }

    // Amount cannot be 0 or negative.
    if (amount <= 0) {
      return false;
    }

    // Category validation
    if (category.trim().isEmpty) {
      return false;
    }

    final Expense expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      amount: amount,
      category: category,
      date: date,
    );

    _expenses.add(expense);

    // Tell widgets that data has changed.
    notifyListeners();

    return true;
  }

  // ==========================================================
  // Delete Expense
  // ==========================================================

  bool deleteExpense(String id) {
    final int oldLength = _expenses.length;

    _expenses.removeWhere(
      (expense) => expense.id == id,
    );

    // Check whether an expense was actually deleted.
    final bool deleted = _expenses.length < oldLength;

    if (deleted) {
      notifyListeners();
    }

    return deleted;
  }

  // ==========================================================
  // Clear All Expenses
  // ==========================================================

  void clearExpenses() {
    if (_expenses.isEmpty) {
      return;
    }

    _expenses.clear();

    notifyListeners();
  }

  // ==========================================================
  // Total Expense
  // ==========================================================

  double get totalExpense {
    double total = 0;

    for (final Expense expense in _expenses) {
      total += expense.amount;
    }

    return total;
  }

  // ==========================================================
  // Today's Total Expense
  // ==========================================================

  double get todayExpense {
    final DateTime now = DateTime.now();

    double total = 0;

    for (final Expense expense in _expenses) {
      if (_isSameDay(expense.date, now)) {
        total += expense.amount;
      }
    }

    return total;
  }

  // ==========================================================
  // Highest Expense
  // ==========================================================

  double get highestExpense {
    if (_expenses.isEmpty) {
      return 0;
    }

    double highest = _expenses.first.amount;

    for (final Expense expense in _expenses) {
      if (expense.amount > highest) {
        highest = expense.amount;
      }
    }

    return highest;
  }

  // ==========================================================
  // Lowest Expense
  // ==========================================================

  double get lowestExpense {
    if (_expenses.isEmpty) {
      return 0;
    }

    double lowest = _expenses.first.amount;

    for (final Expense expense in _expenses) {
      if (expense.amount < lowest) {
        lowest = expense.amount;
      }
    }

    return lowest;
  }

  // ==========================================================
  // Average Expense
  // ==========================================================

  double get averageExpense {
    if (_expenses.isEmpty) {
      return 0;
    }

    return totalExpense / _expenses.length;
  }

  // ==========================================================
  // Category Total
  // ==========================================================

  double categoryTotal(String category) {
    double total = 0;

    for (final Expense expense in _expenses) {
      if (expense.category.toLowerCase() ==
          category.toLowerCase()) {
        total += expense.amount;
      }
    }

    return total;
  }

  // ==========================================================
  // Food Total
  // ==========================================================

  double get foodTotal {
    return categoryTotal('Food');
  }

  // ==========================================================
  // Transport Total
  // ==========================================================

  double get transportTotal {
    return categoryTotal('Transport');
  }

  // ==========================================================
  // Shopping Total
  // ==========================================================

  double get shoppingTotal {
    return categoryTotal('Shopping');
  }

  // ==========================================================
  // Other Total
  // ==========================================================

  double get otherTotal {
    return categoryTotal('Other');
  }

  // ==========================================================
  // Filter - All
  // ==========================================================

  List<Expense> getAllExpenses() {
    return List.unmodifiable(_expenses);
  }

  // ==========================================================
  // Filter - Today
  // ==========================================================

  List<Expense> getTodayExpenses() {
    final DateTime now = DateTime.now();

    return _expenses.where((expense) {
      return _isSameDay(expense.date, now);
    }).toList();
  }

  // ==========================================================
  // Filter - This Week
  // ==========================================================

  List<Expense> getThisWeekExpenses() {
    final DateTime now = DateTime.now();

    // DateTime.weekday:
    // Monday = 1
    // Tuesday = 2
    // ...
    // Sunday = 7

    final DateTime startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(
      Duration(days: now.weekday - 1),
    );

    final DateTime endOfWeek = startOfWeek.add(
      const Duration(days: 7),
    );

    return _expenses.where((expense) {
      return !expense.date.isBefore(startOfWeek) &&
          expense.date.isBefore(endOfWeek);
    }).toList();
  }

  // ==========================================================
  // Filter - This Month
  // ==========================================================

  List<Expense> getThisMonthExpenses() {
    final DateTime now = DateTime.now();

    return _expenses.where((expense) {
      return expense.date.year == now.year &&
          expense.date.month == now.month;
    }).toList();
  }

  // ==========================================================
  // Filter - By Category
  // ==========================================================

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((expense) {
      return expense.category.toLowerCase() ==
          category.toLowerCase();
    }).toList();
  }

  // ==========================================================
  // Get Filtered Expenses
  // ==========================================================

  List<Expense> getFilteredExpenses({
    required String filter,
    String? category,
  }) {
    switch (filter) {
      case 'All':
        return getAllExpenses();

      case 'Today':
        return getTodayExpenses();

      case 'This Week':
        return getThisWeekExpenses();

      case 'This Month':
        return getThisMonthExpenses();

      case 'By Category':
        if (category == null || category.trim().isEmpty) {
          return [];
        }

        return getExpensesByCategory(category);

      default:
        return getAllExpenses();
    }
  }

  // ==========================================================
  // Calculate Total From A Specific List
  // ==========================================================

  double calculateTotal(List<Expense> expenses) {
    double total = 0;

    for (final Expense expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  // ==========================================================
  // Calculate Highest From A Specific List
  // ==========================================================

  double calculateHighest(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return 0;
    }

    double highest = expenses.first.amount;

    for (final Expense expense in expenses) {
      if (expense.amount > highest) {
        highest = expense.amount;
      }
    }

    return highest;
  }

  // ==========================================================
  // Calculate Lowest From A Specific List
  // ==========================================================

  double calculateLowest(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return 0;
    }

    double lowest = expenses.first.amount;

    for (final Expense expense in expenses) {
      if (expense.amount < lowest) {
        lowest = expense.amount;
      }
    }

    return lowest;
  }

  // ==========================================================
  // Calculate Average From A Specific List
  // ==========================================================

  double calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return 0;
    }

    return calculateTotal(expenses) / expenses.length;
  }

  // ==========================================================
  // Check Same Date
  // ==========================================================

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}