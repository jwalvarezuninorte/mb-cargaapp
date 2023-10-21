import 'package:flutter/material.dart';

// C72B32 - red (used)
// EEF2F4 - base
// 8F99AC - base dark
// 2B2D40 - dark (used)

// C8D4FE - light blue

class AppTheme {
  // Colors
  // static const Color primary = Color(0xff4FA5F5);
  static const Color dark = Color(0xff2B2D40); //081D30
  static const Color secondary = Color(0xffC8D4FE);
  static const Color primary = Color(0xff4f76f5); // 0xff4f76f5
  static const Color base = Color(0xffEEF2F4);

  // padding, margin, etc
  static const double padding = 24;
  static const double defaultRadius = 12;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    useMaterial3: true,
    primaryColor: AppTheme.primary,
    appBarTheme: const AppBarTheme(
      color: AppTheme.base,
      // backgroundColor: AppTheme.base,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppTheme.dark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: false,
      toolbarHeight: 82,
    ),
    iconTheme: const IconThemeData(
      color: AppTheme.primary,
      size: 20,
    ),
    // ignore: deprecated_member_use
    // accentIconTheme: const IconThemeData(
    //   color: AppTheme.primary,
    //   size: 100,
    // ),
    primaryIconTheme: const IconThemeData(
      color: AppTheme.primary,
      size: 200,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(
        color: AppTheme.dark,
        fontSize: 16,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyle(
          color: AppTheme.dark.withOpacity(0.4),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        prefixIconColor: AppTheme.dark.withOpacity(0.3),
        fillColor: AppTheme.dark.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          borderSide: BorderSide(color: AppTheme.dark.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
          borderSide: BorderSide(
            color: AppTheme.dark.withOpacity(0.1),
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: Colors.red.withOpacity(0.4),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.base,
        backgroundColor: AppTheme.primary,
        minimumSize: const Size(double.infinity, 40),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        ),
        textStyle: TextStyle(
          fontSize: 16,
          // color: AppTheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      hintStyle: TextStyle(
        color: AppTheme.dark.withOpacity(0.4),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      prefixIconColor: AppTheme.dark.withOpacity(0.3),
      fillColor: AppTheme.dark.withOpacity(0.05),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        borderSide: BorderSide(color: AppTheme.dark.withOpacity(0.05)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        borderSide: BorderSide(color: AppTheme.dark.withOpacity(0.05)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
        borderSide: BorderSide(
          color: AppTheme.dark.withOpacity(0.1),
          width: 2,
        ),
      ),
      labelStyle: TextStyle(
        color: AppTheme.dark.withOpacity(0.6),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    // dropdownMenuTheme: DropdownMenuThemeData(
    //   inputDecorationTheme: InputDecorationTheme(
    //     fillColor: AppTheme.textPrimary.withOpacity(0.05),
    //     contentPadding: const EdgeInsets.symmetric(
    //       horizontal: AppTheme.padding,
    //       vertical: AppTheme.padding,
    //     ),
    //   ),
    //   textStyle: const TextStyle(
    //     fontSize: 14,
    //     fontWeight: FontWeight.bold,
    //   ),
    // ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppTheme.base,
      selectedItemColor: AppTheme.dark,
      unselectedItemColor: AppTheme.dark.withOpacity(0.6),
      type: BottomNavigationBarType.fixed,
      elevation: 20,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      selectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),

    // text theme properties
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppTheme.dark,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppTheme.dark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: AppTheme.dark,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppTheme.dark,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: AppTheme.dark,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      titleLarge: TextStyle(
        color: AppTheme.dark,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        color: AppTheme.dark,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppTheme.dark,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: AppTheme.dark,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppTheme.dark.withOpacity(0.6),
      ),
    ),
  );
}
