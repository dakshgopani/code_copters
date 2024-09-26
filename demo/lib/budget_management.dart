import 'package:flutter/material.dart';

class BudgetManagementScreen extends StatelessWidget {
  final List<Map<String, dynamic>> budgetItems = [
    {'category': 'Venue', 'amount': 1000},
    {'category': 'Catering', 'amount': 500},
    {'category': 'Decorations', 'amount': 300},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Budget Management'),
        ),
        body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: budgetItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(budgetItems[index]['category']),
                      subtitle: Text('Amount: \$${budgetItems[index]['amount']}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Action to add a new budget item
                  },
                  child: Text('Add Expense'),
                ),
              ),
            ],
             ),
            );
      }
}