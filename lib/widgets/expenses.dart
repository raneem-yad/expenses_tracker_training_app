import 'package:expenses_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';
import 'new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>  NewExpense(onAddNewExpense: _addNewExpense,),
    );
  }

  void _addNewExpense(Expense newExpense){
    setState(() {
      _registeredExpenses.add(newExpense);
    });
  }

  void _removeExpense(Expense expense){
    final expense_index = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 3),
          action: SnackBarAction(label: "Undo!", onPressed: (){
            setState(() {
              _registeredExpenses.insert(expense_index, expense);
            });
          }),
          content: const Text("Expense was Deleted!"))
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text("No Expenses Found!"),);

    if(_registeredExpenses.isNotEmpty) {
      content = ExpensesList(expenses: _registeredExpenses,onRemove: _removeExpense,);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          const Text('The chart'),
          Expanded(
            child: content,
          ),
        ],
      ),
    );
  }
}