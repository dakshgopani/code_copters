import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<dynamic> createdEvents = [];
  List<dynamic> joinedEvents = [];
  bool isLoading = true;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  // Fetch the logged-in user's email from SharedPreferences
  Future<void> fetchUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
    if (userEmail != null) {
      fetchEvents(userEmail!);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch events using the logged-in user's email
  Future<void> fetchEvents(String email) async {
    try {
      final response = await http.get(Uri.parse(
          'https://66fc384bd9202c937bdb0639--clever-taiyaki-0781e4.netlify.app/.netlify/functions/get_event?email=$email'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          createdEvents = data['event_organized'] ?? [];
          print(createdEvents);
          joinedEvents = data['joinedEvents'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load events');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Format date from API to a more readable format
  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Events'),
        backgroundColor: Colors.orange,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section for Created Events
            Text(
              'Events Created:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            createdEvents.isEmpty
                ? Text(
              'No created events',
              style: TextStyle(color: Colors.grey),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: createdEvents.length,
              itemBuilder: (context, index) {
                final event = createdEvents[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(event['event_name'] ?? 'No Title'),
                    subtitle: Text(formatDate(event['date'])),
                    tileColor: Colors.orange[50],
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // Section for Joined Events
            Text(
              'Events Joined:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            joinedEvents.isEmpty
                ? Text(
              'No joined events',
              style: TextStyle(color: Colors.grey),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: joinedEvents.length,
              itemBuilder: (context, index) {
                final event = joinedEvents[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(event['event_name'] ?? 'No Title'),
                    subtitle: Text(formatDate(event['date'])),
                    tileColor: Colors.orange[50],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
