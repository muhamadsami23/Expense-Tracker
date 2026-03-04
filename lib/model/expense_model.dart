import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

final uuid = Uuid();

enum Category2 { food, travel, leisure, work, sami}

const categoryIcon = {
  Category2.food: Icons.lunch_dining,
  Category2.travel: Icons.flight_takeoff,
  Category2.leisure: Icons.movie,
  Category2.work: Icons.work,
};

class ExpenseModel {
  ExpenseModel({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category2 category;

  String get formattedDate {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<ExpenseModel> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category2 category;
  final List<ExpenseModel> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // sum = sum + expense.amount
    }

    return sum;
  }
}
