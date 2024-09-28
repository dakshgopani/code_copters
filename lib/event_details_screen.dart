import 'package:flutter/material.dart';
import 'translation_service.dart'; // Ensure to import your translation service.

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;
  final int eventIndex;
  final String selectedLanguage; // Add selectedLanguage parameter

  EventDetailsScreen({
    required this.event,
    required this.eventIndex,
    required this.selectedLanguage,
  });

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late List<Map<String, dynamic>> _expenses;
  TextEditingController _expenseNameController = TextEditingController();
  TextEditingController _expenseAmountController = TextEditingController();
  final TranslationService _translationService = TranslationService();
  Map<String, String> _uiTranslations = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _expenses = List<Map<String, dynamic>>.from(widget.event['expenses']);
    _loadUiTranslations();
  }

  Future<void> _loadUiTranslations() async {
    try {
      final Map<String, String> translations = {
        'eventDetailsTitle': await _translationService.translateText(
            '${widget.event['name']} Details', 'en', widget.selectedLanguage),
        'expensesLabel': await _translationService.translateText(
            'Expenses:', 'en', widget.selectedLanguage),
        'expenseName': await _translationService.translateText(
            'Expense Name', 'en', widget.selectedLanguage),
        'expenseAmount': await _translationService.translateText(
            'Expense Amount', 'en', widget.selectedLanguage),
        'addExpense': await _translationService.translateText(
            'Add Expense', 'en', widget.selectedLanguage),
        'error': await _translationService.translateText(
            'Error', 'en', widget.selectedLanguage),
        'budget': await _translationService.translateText(
            'Budget: ₹${widget.event['budget']}', 'en', widget.selectedLanguage),
        'amountUsed': await _translationService.translateText(
            'Amount Used: ₹${widget.event['used']}', 'en', widget.selectedLanguage),
      };

      setState(() {
        _uiTranslations = translations;
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to load translations: $e");
      setState(() {
        _isLoading = false;
      });
    }
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
          _uiTranslations['error'] ?? 'Error',
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_uiTranslations['eventDetailsTitle'] ?? '${widget.event['name']} Details',
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
                    _uiTranslations['expensesLabel'] ?? 'Expenses:',
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
              _uiTranslations['budget'] ?? 'Budget: ₹${widget.event['budget']}',
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.01),
            Text(
              _uiTranslations['amountUsed'] ?? 'Amount Used: ₹${widget.event['used']}',
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
            labelText: _uiTranslations['expenseName'] ?? 'Expense Name',
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
            labelText: _uiTranslations['expenseAmount'] ?? 'Expense Amount',
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
          child: Text(_uiTranslations['addExpense'] ?? 'Add Expense',
              style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth * 0.1,
              vertical: constraints.maxHeight * 0.015,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ],
    );
  }
}
