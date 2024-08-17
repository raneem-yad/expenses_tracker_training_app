import 'package:flutter/material.dart';

import '../models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _expenseDate ;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1, now.month, now.day);
    final pickedDate = await showDatePicker(context: context, firstDate: firstDate, lastDate: now);
    setState(() {
      _expenseDate = pickedDate;
    });
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
              Expanded(child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text("Amount")
                ),
              ),),
              const SizedBox(width: 10,),
              Expanded(child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_expenseDate == null ?"Select Date": formatter.format(_expenseDate!)),
                  // ! this will never be null
                  IconButton(onPressed: _presentDatePicker, icon: Icon(Icons.calendar_month))
                ],
              ),)
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  print(_titleController.text);
                  print(_amountController.text);
                },
                child: const Text('Save Expense'),
              ),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text("Cancel"))
            ],
          ),
        ],
      ),
    );
  }
}