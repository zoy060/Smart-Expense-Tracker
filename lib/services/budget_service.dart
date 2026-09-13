import 'package:flutter/foundation.dart';

class BudgetService extends ChangeNotifier {
  double _monthlyBudget = 0;

  // ==========================================================
  // Get Budget
  // ==========================================================

  double get monthlyBudget {
    return _monthlyBudget;
  }

  // ==========================================================
  // Set Budget
  // ==========================================================

  bool setMonthlyBudget(double amount) {
    if (amount <= 0) {
      return false;
    }

    _monthlyBudget = amount;

    notifyListeners();

    return true;
  }

  // ==========================================================
  // Clear Budget
  // ==========================================================

  void clearBudget() {
    _monthlyBudget = 0;

    notifyListeners();
  }

  // ==========================================================
  // Remaining Budget
  // ==========================================================

  double remainingBudget(double monthlyExpense) {
    return _monthlyBudget - monthlyExpense;
  }

  // ==========================================================
  // Percentage Used
  // ==========================================================

  double percentageUsed(double monthlyExpense) {
    if (_monthlyBudget <= 0) {
      return 0;
    }

    return (monthlyExpense / _monthlyBudget) * 100;
  }

  // ==========================================================
  // Spending Status
  // ==========================================================

  String spendingStatus(double monthlyExpense) {
    final double percentage =
        percentageUsed(monthlyExpense);

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
}