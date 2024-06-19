import 'package:flutter/material.dart';
import 'package:shopping_list_app/screens/grocery_list.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 147, 229, 250),
    brightness: Brightness.dark,
    surface: const Color.fromARGB(255, 42, 51, 59),
  ),
  textTheme: GoogleFonts.robotoTextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const GroceryListScreen(),
    );
  }
}
