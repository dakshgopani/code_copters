import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final int eventIndex;

  EventDetailsScreen({
    required this.event,
    required this.eventIndex,
  });

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late List<Map<String, dynamic>> _expenses;
  TextEditingController _expenseNameController = TextEditingController();
  TextEditingController _expenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _expenses = List<Map<String, dynamic>>.from(widget.event['expenses']);
  }

  void _addExpense() {
    String name = _expenseNameController.text;
    int amount = int.tryParse(_expenseAmountController.text) ?? 0;
    int remainingBudget = widget.event['budget'] - widget.event['used'];

    if (name.isNotEmpty && amount > 0) {
      if (amount <= remainingBudget) {
        setState(() {
          _expenses.add({'name': name, 'amount': amount});
          widget.event['used'] += amount;
          widget.event['expenses'] = _expenses;
        });
        _expenseNameController.clear();
        _expenseAmountController.clear();
      } else {
        _showErrorDialog('Expense exceeds the remaining budget.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(color: Colors.orange[800]),
        ),
        content: Text(message),
        backgroundColor: Colors.orange[50],
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.orange[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.event['name']} Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBudgetInfo(constraints),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Text(
                    'Expenses:',
                    style: TextStyle(
                      fontSize: constraints.maxWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  Expanded(child: _buildExpensesList(constraints)),
                  SizedBox(height: constraints.maxHeight * 0.02),
                  _buildExpenseInputs(constraints),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context, widget.event),
        child: Icon(Icons.check, color: Colors.white),
        backgroundColor: Colors.orange[700],
      ),
    );
  }

  Widget _buildBudgetInfo(BoxConstraints constraints) {
    return Card(
      elevation: 4,
      color: Colors.orange[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(constraints.maxWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget: ₹${widget.event['budget']}',
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Text(
              'Amount Used: ₹${widget.event['used']}',
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.04,
                color: Colors.orange[700],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            LinearProgressIndicator(
              value: widget.event['used'] / widget.event['budget'],
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.event['used'] / widget.event['budget'] > 0.9
                    ? Colors.red
                    : Colors.orange[400]!,
              ),
              minHeight: constraints.maxHeight * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.01),
          color: Colors.orange[100],
          child: ListTile(
            title: Text(
              expense['name'],
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.04,
                color: Colors.orange[800],
              ),
            ),
            trailing: Text(
              '₹${expense['amount']}',
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseInputs(BoxConstraints constraints) {
    return Column(
      children: [
        TextField(
          controller: _expenseNameController,
          decoration: InputDecoration(
            labelText: 'Expense Name',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[700]!),
            ),
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.01),
        TextField(
          controller: _expenseAmountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Expense Amount',
            labelStyle: TextStyle(color: Colors.orange[800]),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange[700]!),
            ),
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.02),
        ElevatedButton(
          onPressed: _addExpense,
          child: Text('Add Expense', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.1,
              vertical: constraints.maxHeight * 0.015,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}
