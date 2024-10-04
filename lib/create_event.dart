import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

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

  void _createEvent() {
    var uuid = Uuid();
    eventCode = uuid.v4();
    String qrData = "Event Code: $eventCode\nOrganized by: $organizerName";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Event Created!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 20),
              Text("Your Event Code is $eventCode"),
            ],
          ),
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
              _buildBeautifulTitle(),
              const SizedBox(height: 24),
              _buildElevatedForm(),
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

  Widget _buildBeautifulTitle() {
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

  Widget _buildElevatedForm() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFormField(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Organizer Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  organizerName = value;
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildFormField(
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFormField(
              child: Autocomplete<String>(
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
                    TextEditingController controller,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  eventTypeController.text = selectedEventType ?? '';
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Event Type',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildDateAndTimeFields(),
            const SizedBox(height: 16),
            _buildFormField(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFormField(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Budget',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 16),
            _buildGuestCountDropdown(),
            const SizedBox(height: 16),
            _buildFormField(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: child,
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

  Widget _buildGuestCountDropdown() {
    return _buildFormField(
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          labelText: 'Number of Guests',
          border: OutlineInputBorder(),
        ),
        value: selectedGuestCount,
        onChanged: (int? newValue) {
          setState(() {
            selectedGuestCount = newValue!;
          });
        },
        items: guestCounts.map((int value) {
          return DropdownMenuItem(value: value, child: Text(value.toString()));
        }).toList(),
      ),
    );
  }
}
