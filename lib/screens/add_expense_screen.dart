import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/expense_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {

  // ==========================================================
  // Controllers
  // ==========================================================

  final TextEditingController _titleController =
      TextEditingController();

  final TextEditingController _amountController =
      TextEditingController();

  // ==========================================================
  // Form
  // ==========================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // ==========================================================
  // Variables
  // ==========================================================

  String _selectedCategory = 'Food';

  DateTime _selectedDate = DateTime.now();

  bool _isSaving = false;

  // ==========================================================
  // Categories
  // ==========================================================

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Other',
  ];

  // ==========================================================
  // Dispose
  // ==========================================================

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  // ==========================================================
  // Build
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Expense',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
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
                  'Add New Expense',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Enter your expense information below.',
                ),

                const SizedBox(height: 25),

                // ==================================================
                // Title
                // ==================================================

                TextFormField(
                  controller: _titleController,
                  textInputAction:
                      TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Expense Title',
                    hintText: 'Example: Lunch',
                    prefixIcon:
                        Icon(Icons.edit_note),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter expense title';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // Amount
                // ==================================================

                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction:
                      TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    hintText: 'Example: 250',
                    prefixIcon: Icon(
                      Icons.payments_outlined,
                    ),
                    prefixText: '৳ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please enter amount';
                    }

                    final double? amount =
                        double.tryParse(
                      value.trim(),
                    );

                    if (amount == null) {
                      return 'Please enter a valid amount';
                    }

                    if (amount <= 0) {
                      return 'Amount must be greater than 0';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // Category
                // ==================================================

                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration:
                      const InputDecoration(
                    labelText: 'Category',
                    prefixIcon:
                        Icon(Icons.category_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map(
                    (category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // Date
                // ==================================================

                InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration:
                        const InputDecoration(
                      labelText: 'Expense Date',
                      prefixIcon:
                          Icon(Icons.calendar_month),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _formatDate(
                        _selectedDate,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // Save
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed:
                        _isSaving
                            ? null
                            : _saveExpense,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSaving
                          ? 'Saving...'
                          : 'Save Expense',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // Cancel
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            Navigator.pop(
                              context,
                            );
                          },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // Date Picker
  // ==========================================================

  Future<void> _selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Select Expense Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // ==========================================================
  // Save Expense
  // ==========================================================

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double? amount =
        double.tryParse(
      _amountController.text.trim(),
    );

    if (amount == null || amount <= 0) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final ExpenseService service =
        context.read<ExpenseService>();

    final bool success =
        service.addExpense(
      title: _titleController.text.trim(),
      amount: amount,
      category: _selectedCategory,
      date: _selectedDate,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Expense added successfully.',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to add expense.',
          ),
        ),
      );
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