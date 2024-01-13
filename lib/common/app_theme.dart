import 'package:flutter/material.dart';

class CustomAppTheme {
  static ThemeData darkOrangeTheme() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.black,
        textTheme:
            const TextTheme(labelLarge: TextStyle(color: Colors.deepOrange)),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.deepOrange),
        )),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange.withOpacity(0.2),
            foregroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Set border radius
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepOrange,
                side: BorderSide(color: Colors.deepOrange.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set border radius
                ))),
        checkboxTheme: CheckboxThemeData(
          shape: const RoundedRectangleBorder(),
          side: const BorderSide(width: 2, color: Colors.deepOrange),
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.deepOrange; // Checked color
            }
            return Colors.black; // Unchecked color
          }),
          checkColor: MaterialStateProperty.all<Color>(Colors.black),
        ),
        indicatorColor: Colors.deepOrange,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: Colors.deepOrange),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrange,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 22)),
        dialogBackgroundColor: Colors.grey[900],
        listTileTheme: const ListTileThemeData(
            iconColor: Colors.deepOrange,
            contentPadding: EdgeInsets.symmetric(horizontal: 24)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepOrange));
  }
}
