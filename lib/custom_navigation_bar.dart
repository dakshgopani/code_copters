import 'package:event_planner/task_management.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'budget_screen.dart';
import 'translation_service.dart'; // Import the translation service
import 'bottom_sheet.dart';
import 'language_state.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  late final NotchBottomBarController _controller;
  late final PageController _pageController;
  final TranslationService _translationService = TranslationService();

  // Text to be translated for each page and navigation item
  final List<String> texts = [
    'Page 1',
    'Page 2',
    'Page 3',
    'Page 4',
    'Page 5',
  ];

  // Store the translated texts
  late Map<String, String> _translatedTexts = {};
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController();
    _pageController = PageController();

    // Trigger the translation of texts
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    try {
      // Access the selected language from LanguageState using Provider
      final selectedLanguage = Provider.of<LanguageState>(context, listen: false).selectedLanguage;

      // Fetch translations based on the selected language
      final translations = await _translationService.translateStrings(texts, selectedLanguage);

      setState(() {
        _translatedTexts = translations;
        _isLoading = false;
        _errorMessage = null; // Clear any previous errors
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load translations: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Show loading spinner while fetching translations
      return Scaffold(
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      // Show error message if translations fail
      return Scaffold(
        body: Center(
          child: Text(
            _errorMessage ?? 'Unknown error',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Build the UI with translated texts
    final List<Widget> bottomBarPages = [
      Container(color: Colors.white, child: Center(child: Text(_translatedTexts['Page 1'] ?? ''))),
      Container(color: Colors.white, child: Center(child: Text(_translatedTexts['Page 2'] ?? ''))),
      Container(color: Colors.white, child: Center(child: Text(_translatedTexts['Page 3'] ?? ''))),
      Container(color: Colors.white, child: Center(child: TaskManagementScreen(
        selectedLanguage: Provider.of<LanguageState>(context, listen: false).selectedLanguage,
      ))), // Keep TaskManagementScreen here
      Container(color: Colors.white, child: Center(child: BudgetScreen(
        selectedLanguage: Provider.of<LanguageState>(context, listen: false).selectedLanguage,
      ))),    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Prevent swipe navigation
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
            itemLabel: _translatedTexts['Page 1'] ?? 'Page 1',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.star, color: Colors.orange),
            activeItem: Icon(Icons.star, color: Colors.orange),
            itemLabel: _translatedTexts['Page 2'] ?? 'Page 2',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.add, color: Colors.orange),
            activeItem: Icon(Icons.add, color: Colors.orange),
            itemLabel: _translatedTexts['Page 3'] ?? 'Page 3',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.group, color: Colors.orange),
            activeItem: Icon(Icons.group, color: Colors.orange),
            itemLabel: _translatedTexts['Page 4'] ?? 'Page 4',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: Colors.orange),
            activeItem: Icon(Icons.person, color: Colors.orange),
            itemLabel: _translatedTexts['Page 5'] ?? 'Page 5',
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
