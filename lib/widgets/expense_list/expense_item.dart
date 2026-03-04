import 'package:expense_tracker/model/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget{
  const ExpenseItem({super.key,required this.expense});

  final ExpenseModel expense;
  @override
  Widget build(context){
    return Card(child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(expense.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          const SizedBox(height: 4,),
          Row(
            children: [
              Text('\Rs. ${expense.amount.toStringAsFixed(2)}'),
              const Spacer(),
              Row(
                children: [
                  Icon(categoryIcon[expense.category]),
                  SizedBox(width: 8,),
                  Text(expense.formattedDate),
                ],
              ),
            ],
          ),
        ],
      ),
    ),);
  }
}