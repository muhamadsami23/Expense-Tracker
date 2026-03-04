import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';

import 'package:expense_tracker/model/expense_model.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});

  final void Function (ExpenseModel expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _textcontroller = TextEditingController();
  final _amountcontroller = TextEditingController();
  DateTime? _selectedDate;
  Category2 _selectedCategory = Category2.leisure;

  void _datepicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _saveExpense() {
    final enteredAmount = double.tryParse(_amountcontroller.text);
    final bool amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_textcontroller.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
          showCupertinoDialog(context: context, builder: (ctx)=>CupertinoAlertDialog(
            title: Text('Invalid Input'),
          content: Text(
            'Please make sure Valid Amount, Category, Amount and Date are selected.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text('Okay'),
            ),
          ],
          ));
      return;
    }
    widget.onAddExpense(ExpenseModel(title: _textcontroller.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }


  @override
  void dispose() {
    _textcontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;


      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16,48,16,keyboardSpace + 16),
            child: Column(
              children: [
                TextField(
                  maxLength: 50,
                  controller: _textcontroller,
                  decoration: InputDecoration(label: Text('Title')),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _amountcontroller,
                        decoration: InputDecoration(
                          label: Text('Amount'),
                          prefixText: 'Rs. ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No Date Selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _datepicker,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category2.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        } else {
                          return;
                        }
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: _saveExpense,
                      child: Text('Save Expense'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(86, 121, 4, 4),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      
  }
}

