import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:event_planner/create_event.dart';
import 'package:event_planner/join_event.dart';

class CustomBottomSheet {
  static void show(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      topRadius: const Radius.circular(30),
      expand:
          false, // This ensures the bottom sheet doesn't expand to fill the screen
      builder: (context) {
        return Material(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // This makes the column take minimum required space
                children: [
                  // Add a line and close button at the top
                  SizedBox(
                    height: 48, // Fixed height for the top bar
                    child: Stack(
                      children: [
                        // Center handle
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider line
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Create Event'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateEventScreen(),
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_add),
                    title: const Text('Join Event'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => JoinEventScreen(),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
