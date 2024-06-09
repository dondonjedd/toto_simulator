import 'package:flutter/material.dart';
import 'main_page/ts_main_page.dart';

void main() {
  runApp(const TotoSimulatorApp());
}

class TotoSimulatorApp extends StatelessWidget {
  const TotoSimulatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TotoSimulatorMainPage(),
    );
  }
}
