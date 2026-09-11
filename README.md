# smart_expense_tracker

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

----------------------------------
----------------------------------
# Assignment Title: Smart Expense Tracker

## Objective
Build a Flutter application that allows users to manage their daily expenses and provides useful calculations and logical insights.
## Requirements
Create an app where the user can:

Add an expense with:

- Expense title
- Amount
- Category
- Date
- Display all expenses in a list.

### Calculate and display:
- Total expense
- Today's total expense
- Highest expense
- Lowest expense
- Average expense

### Implement category-wise calculation:

- Food total
- Transport total
- Shopping total
- Other total
- Add a Budget feature:
- User enters a monthly budget.
- Calculate the remaining budget.
- If expenses exceed the budget, show an appropriate warning.

### Add a filter option:


- All

- Today

- This week

- This month

- By category

Add an expense deletion feature.


#### Add a spending status based on the budget:


- Below 50% → Safe

- 50%–80% → Moderate

- 80%–100% → Warning

- Above 100% → Over Budget

## Important Logic Conditions
The app should correctly handle cases such as:

No expenses added.

Amount cannot be 0 or negative.

Budget cannot be negative.

Deleting an expense must update all calculations.

Adding an expense must immediately update the totals.

Category totals must change dynamically.

Filtering expenses must also update the displayed calculations.

## UI Requirements
Use appropriate Flutter widgets such as:

- Scaffold

- AppBar

- TextField

- DropdownButton / DropdownButtonFormField

- DatePicker

- ListView.builder

- Card

- AlertDialog

- FloatingActionButton

## Submission
Must submit using github repository link. 

Restriction: Do not use Firebase, REST API, or database. Focus mainly on Flutter UI, Dart logic, state management, calculations, filtering, and conditional statements.

----------------------------------
----------------------------------

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
