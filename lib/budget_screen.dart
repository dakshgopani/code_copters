import 'package:flutter/material.dart';
import 'event_details_screen.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

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

  void _updateEvent(int index, Map<String, dynamic> updatedEvent) {
    setState(() {
      _events[index] = updatedEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Budget Management',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                            eventIndex: index,
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
                                    'Budget: ₹${event['budget']}',
                                    style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.035,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Used: ₹${event['used']}',
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
                              '${(progress * 100).toStringAsFixed(1)}% used',
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
