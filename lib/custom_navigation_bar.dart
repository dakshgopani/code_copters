import 'package:event_planner/task_management.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'bottom_sheet.dart';
import 'budget_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late final NotchBottomBarController _controller;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Container(color: Colors.white, child: Center(child: Text('Page 1'))),
      Container(color: Colors.white, child: Center(child: Text('Page 2'))),
      Container(color: Colors.white, child: Center(child: Text('Page 3'))),
      Container(
          color: Colors.white, child: Center(child: TaskManagementScreen())),
      Container(color: Colors.white, child: Center(child: BudgetScreen())),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swipe navigation
        children: bottomBarPages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: true,
        shadowElevation: 5,
        kBottomRadius: 28.0,
        notchColor: Colors.black87,
        durationInMilliSeconds: 300,
        itemLabelStyle: const TextStyle(fontSize: 10),
        elevation: 1,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.home_filled, color: Colors.orange),
            activeItem: Icon(Icons.home_filled, color: Colors.orange),
            itemLabel: 'Page 1',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.star, color: Colors.orange),
            activeItem: Icon(Icons.star, color: Colors.orange),
            itemLabel: 'Page 2',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add, color: Colors.orange),
            activeItem: Icon(Icons.add, color: Colors.orange),
            itemLabel: 'Page 3',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.group, color: Colors.orange),
            activeItem: Icon(Icons.group, color: Colors.orange),
            itemLabel: 'Page 4',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.orange),
            activeItem: Icon(Icons.person, color: Colors.orange),
            itemLabel: 'Page 5',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            // Open the modal bottom sheet when index 2 is tapped
            CustomBottomSheet.show(context);
          } else {
            // For other indices, just jump to the selected page
            _pageController.jumpToPage(index);
          }
        },
        kIconSize: 24.0,
      ),
    );
  }
}
