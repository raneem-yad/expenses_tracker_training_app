import 'package:flutter/material.dart';

import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddNewExpense});
  final void Function(Expense expense) onAddNewExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _intialDropdownValue = Category.values[0];
  DateTime? _expenseDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _expenseDate = pickedDate;
    });
  }

  void _submitNewExpense(){
    final enteredAmount = double.tryParse(_amountController
        .text); // tryParse('Hello') => null, tryParse('1.12') => 1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _expenseDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

  //   all data is valid
    final expense = Expense(title: _titleController.text.trim(), amount: enteredAmount,
        date:_expenseDate!, category: _intialDropdownValue);
    widget.onAddNewExpense(expense);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixText: '\$ ', label: Text("Amount")),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_expenseDate == null
                        ? "Select Date"
                        : formatter.format(_expenseDate!)),
                    // ! this will never be null
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16,),
          Row(
            children: [
              DropdownButton<Category>(
                  value: _intialDropdownValue,
                  items: Category.values
                      .map((item) => DropdownMenuItem(
                          value: item, child: Text(item.name.toUpperCase())))
                      .toList(),
                  onChanged: (Category? value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _intialDropdownValue = value;
                    });
                  }),
              const Spacer(),
              ElevatedButton(
                onPressed: _submitNewExpense,
                child: const Text('Save Expense'),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          ),
        ],
      ),
    );
  }
}
