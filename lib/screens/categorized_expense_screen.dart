import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/database_helper.dart';

class CategorizedExpenseScreen extends StatefulWidget {
  const CategorizedExpenseScreen({super.key});

  @override
  State<CategorizedExpenseScreen> createState() => _CategorizedExpenseScreenState();
}

class _CategorizedExpenseScreenState extends State<CategorizedExpenseScreen> {
  late Future<List<Expense>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _refreshExpenses();
  }

  void _refreshExpenses() {
    setState(() {
      _expensesFuture = DatabaseHelper.instance.getExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gastos por Categoría')),
      body: FutureBuilder<List<Expense>>(
        future: _expensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay gastos registrados'));
          }

          final expenses = snapshot.data!;
          Map<String, List<Expense>> categorizedExpenses = {};

          for (var expense in expenses) {
            categorizedExpenses.putIfAbsent(expense.category, () => []).add(expense);
          }

          return ListView(
            children: categorizedExpenses.entries.map((entry) {
              return ExpansionTile(
                title: Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                children: entry.value.map((expense) {
                  return ListTile(
                    title: Text(expense.title),
                    subtitle: Text('€${expense.amount.toStringAsFixed(2)} - ${expense.date.toLocal()}'),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
