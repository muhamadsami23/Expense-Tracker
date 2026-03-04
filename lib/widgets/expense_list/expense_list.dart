// import 'package:expense_tracker/model/expense_model.dart';
// import 'package:expense_tracker/widgets/expense_list/expense_item.dart';
// import 'package:flutter/material.dart';

// class ExpenseList extends StatelessWidget {
//   const ExpenseList({super.key, required this.expenses});

//   final List<ExpenseModel> expenses;

//   @override
//   Widget build(context) {
//     return ListView.builder(
//       itemCount: expenses.length,
//       itemBuilder: (ctx, index) => ExpenseItem(expense: expenses[index]),
//     );
//   }
// }
// expense_list.dart
import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/widgets/expense_list/expense_item.dart'; // ✅ Use your item widget
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onRemove,
  });

  final List<ExpenseModel> expenses;

  final void Function(ExpenseModel expense) onRemove;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        key: ValueKey(expenses[index]),
        onDismissed: (direction) {
          onRemove(expenses[index]);
        },
        child: ExpenseItem(expense: expenses[index]),
      ),
    );
  }
}
