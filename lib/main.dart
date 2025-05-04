import 'package:flutter/material.dart';
import 'large_screens.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citrus planer',
      home: const AppPageManager(title: 'Citrus planer'),
    );
  }
}

class AppPageManager extends StatefulWidget {
  const AppPageManager({super.key, required this.title});

  final String title;

  @override
  State<AppPageManager> createState() => _AppPageManagerState();
}

class _AppPageManagerState extends State<AppPageManager> {
  int _page = 0;

  void changePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_page == 0) {
      return HomePage();
    } else {
      return Placeholder();
    }
  }
}


