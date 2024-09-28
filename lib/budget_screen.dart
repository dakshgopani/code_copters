import 'package:flutter/material.dart';
import 'event_details_screen.dart';
import 'translation_service.dart'; // Make sure to import your TranslationService

class BudgetScreen extends StatefulWidget {
  final String selectedLanguage;

  const BudgetScreen({super.key, required this.selectedLanguage});

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Map<String, dynamic>> _events = [
    {'name': 'Birthday Party', 'budget': 5000, 'used': 3500, 'expenses': []},
    {'name': 'Wedding', 'budget': 20000, 'used': 18000, 'expenses': []},
    {'name': 'Office Party', 'budget': 10000, 'used': 7000, 'expenses': []},
    {'name': 'Holiday Trip', 'budget': 15000, 'used': 12000, 'expenses': []},
    {'name': 'Charity Event', 'budget': 3000, 'used': 2500, 'expenses': []},
  ];

  Map<String, String> _uiTranslations = {};
  bool _isLoading = true;
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _loadUiTranslations();
  }

  Future<void> _loadUiTranslations() async {
    try {
      final Map<String, String> translations = {
        'budgetManagement': await _translationService.translateText(
            'Budget Management', 'en', widget.selectedLanguage),
        'budget': await _translationService.translateText(
            'Budget:', 'en', widget.selectedLanguage),
        'used': await _translationService.translateText(
            'Used:', 'en', widget.selectedLanguage),
        'percentUsed': await _translationService.translateText(
            '% used', 'en', widget.selectedLanguage),
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

  void _updateEvent(int index, Map<String, dynamic> updatedEvent) {
    setState(() {
      _events[index] = updatedEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: Text(
          _uiTranslations['budgetManagement'] ?? 'Budget Management',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange[700],
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(constraints.maxWidth * 0.03),
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  final double progress = event['used'] / event['budget'];

                  return GestureDetector(
                    onTap: () async {
                      final updatedEvent = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(
                            event: event,
                            eventIndex: index, selectedLanguage: widget.selectedLanguage,
                          ),
                        ),
                      );

                      if (updatedEvent != null) {
                        _updateEvent(index, updatedEvent);
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      color: Colors.orange[50],
                      child: Padding(
                        padding: EdgeInsets.all(constraints.maxWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['name'],
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[800],
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${_uiTranslations['budget'] ?? 'Budget:'} ₹${event['budget']}',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.035,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    '${_uiTranslations['used'] ?? 'Used:'} ₹${event['used']}',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.035,
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: constraints.maxHeight * 0.015),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  progress > 0.9
                                      ? Colors.red
                                      : Colors.orange[400]!,
                                ),
                                minHeight: constraints.maxHeight * 0.01,
                              ),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.01),
                            Text(
                              '${(progress * 100).toStringAsFixed(1)}% ${_uiTranslations['percentUsed'] ?? '% used'}',
                              style: TextStyle(
                                fontSize: constraints.maxWidth * 0.03,
                                color: Colors.orange[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}