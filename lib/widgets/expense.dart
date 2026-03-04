import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/widgets/expense_list/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/data/local/db_connection.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expense> {
  DbConnection db = DbConnection.getInstance;

  List<ExpenseModel> _registeredExpense = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() async {
    final List<Map<String, dynamic>> rawData = await db.getAll();

    final List<ExpenseModel> loadedExpenses = rawData.map((map) {
      return ExpenseModel(
        id: map['id'],
        title: map['title'],
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['Record_Date']),
        category: Category2.values.firstWhere(
          (cat) => cat.name == map['Category'],
        ),
      );
    }).toList();

    setState(() {
      _registeredExpense = loadedExpenses;
    });
  }

  void _addExpense() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _saveExpense),
    );
  }

  void _saveExpense(ExpenseModel expense) {
    setState(() {
      _registeredExpense.add(expense);
      saveExpenseinDB(expense);
    });
  }

  void saveExpenseinDB(ExpenseModel expense) async {
    bool rowAffected = await db.addExpenseDB(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      date: expense.date.toIso8601String(),
      category: expense.category.name,
    );
    if (rowAffected == true) {
      print("Expense Added");
    }
  }

  void deleteExpenseinDB(ExpenseModel expense) async {
    await db.deleteExpenseinDB(id: expense.id);
  }

  void _removeExpense(ExpenseModel expense) async {
    final expenseIndex = _registeredExpense.indexOf(expense);

    // Delete from DB first
    deleteExpenseinDB(expense);

    setState(() {
      _registeredExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense Deleted'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
              saveExpenseinDB(expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(child: Text('No Expense found'));

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registeredExpense,
        onRemove: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Expense Tracker',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        actions: [IconButton(onPressed: _addExpense, icon: Icon(Icons.add))],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpense),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpense)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
