import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  String? selectedEventType;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String organizerName = "";
  int selectedGuestCount = 1;
  String? eventCode;
  String loggedInUserEmail = "";

  final List<String> eventTypes = [
    'Birthday Party',
    'Wedding',
    'Conference',
    'Workshop',
    'Concert',
    'Other'
  ];

  final List<int> guestCounts = List.generate(100, (index) => index + 1);
  final TextEditingController eventTypeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    if (email != null) {
      setState(() {
        loggedInUserEmail = email;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _createEvent() async {
    var uuid = Uuid();
    eventCode = uuid.v4();

    // Prepare the request body using input field values
    final requestBody = {
      "email": loggedInUserEmail,
      "event": {
        "event_name": eventTypeController.text, // Capture event name
        "organizer_name": organizerName,
        "event_type": selectedEventType ?? "Conference",
        "date": "${selectedDate.toLocal()}".split(' ')[0],
        "time": selectedTime.format(context),
        "location": locationController.text, // Capture location
        "budget": int.tryParse(budgetController.text) ?? 0, // Capture budget
        "guests": selectedGuestCount,
        "description": descriptionController.text // Capture description
      }
    };

    // Make the API call
    final response = await http.post(
      Uri.parse(
          'https://66fc384bd9202c937bdb0639--clever-taiyaki-0781e4.netlify.app/.netlify/functions/add_event'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    String qrData = "Event Code: $eventCode\nOrganized by: $organizerName";

    if (response.statusCode == 200) {
      // Show success dialog
      _showDialog('Event Created!', qrData, true);
    } else {
      // Handle error
      _showDialog('Error', 'Failed to create event. Please try again.', false);
    }
  }

  void _showDialog(String title, String content, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: isSuccess
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QrImageView(
                      data: content,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 20),
                    Text(content),
                  ],
                )
              : Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              const SizedBox(height: 24),
              _buildForm(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('CREATE EVENT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Colors.orange.shade100, Colors.white]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Create a New Event',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          ),
          SizedBox(height: 8),
          Text(
            'Fill in the details to set up your perfect event',
            style: TextStyle(fontSize: 16, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField('Organizer Name', (value) => organizerName = value),
            const SizedBox(height: 16),
            _buildTextField(
                'Event Name', (value) => eventTypeController.text = value),
            const SizedBox(height: 16),
            _buildEventTypeField(),
            const SizedBox(height: 16),
            _buildDateAndTimeFields(),
            const SizedBox(height: 16),
            _buildTextField(
                'Location', (value) => locationController.text = value),
            const SizedBox(height: 16),
            _buildTextField('Budget', (value) => budgetController.text = value,
                prefixIcon: const Icon(Icons.attach_money),
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildGuestCountDropdown(),
            const SizedBox(height: 16),
            _buildTextField(
                'Description', (value) => descriptionController.text = value,
                maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {Widget? prefixIcon,
      int maxLines = 1,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon,
      ),
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildEventTypeField() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return eventTypes.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        setState(() {
          selectedEventType = selection;
        });
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return _buildTextField(
          'Event Type',
          (value) {
            // Update the selected event type on change
            setState(() {
              selectedEventType = value;
              textController.text = value; // Update the text controller
            });
          },
          maxLines: 1,
          keyboardType: TextInputType.text,
        );
      },
    );
  }

  Widget _buildDateAndTimeFields() {
    return Row(
      children: [
        Expanded(
          child: _buildFormField(
            child: TextFormField(
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                  text: "${selectedDate.toLocal()}".split(' ')[0]),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildFormField(
            child: TextFormField(
              readOnly: true,
              onTap: () => _selectTime(context),
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.access_time),
              ),
              controller:
                  TextEditingController(text: selectedTime.format(context)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGuestCountDropdown() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Number of Guests',
        border: OutlineInputBorder(),
      ),
      value: selectedGuestCount,
      items: guestCounts.map((int count) {
        return DropdownMenuItem<int>(
          value: count,
          child: Text('$count'),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          selectedGuestCount = newValue!;
        });
      },
    );
  }
}
