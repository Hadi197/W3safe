import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2563EB); // Blue-600
  static const Color secondaryColor = Color(0xFF10B981); // Green-500
  static const Color errorColor = Color(0xFFEF4444); // Red-500
  static const Color warningColor = Color(0xFFF59E0B); // Amber-500
  static const Color successColor = Color(0xFF10B981); // Green-500
  
  static const Color backgroundColor = Color(0xFFF9FAFB); // Gray-50
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  static const Color textPrimary = Color(0xFF111827); // Gray-900
  static const Color textSecondary = Color(0xFF6B7280); // Gray-500
  static const Color textDisabled = Color(0xFF9CA3AF); // Gray-400
  
  // Priority Colors
  static const Color priorityLow = Color(0xFF6B7280); // Gray-500
  static const Color priorityMedium = Color(0xFFF59E0B); // Amber-500
  static const Color priorityHigh = Color(0xFFF97316); // Orange-500
  static const Color priorityCritical = Color(0xFFEF4444); // Red-500
  
  // Status Colors
  static const Color statusDraft = Color(0xFF6B7280); // Gray-500
  static const Color statusReported = Color(0xFF3B82F6); // Blue-500
  static const Color statusInvestigating = Color(0xFFF59E0B); // Amber-500
  static const Color statusResolved = Color(0xFF10B981); // Green-500
  static const Color statusClosed = Color(0xFF8B5CF6); // Purple-500
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: cardColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textDisabled,
        ),
      ),
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    );
  }
  
  // Helper methods for priority colors
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return priorityLow;
      case 'medium':
        return priorityMedium;
      case 'high':
        return priorityHigh;
      case 'critical':
        return priorityCritical;
      default:
        return priorityMedium;
    }
  }
  
  // Helper methods for status colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return statusDraft;
      case 'reported':
        return statusReported;
      case 'investigating':
        return statusInvestigating;
      case 'resolved':
        return statusResolved;
      case 'closed':
        return statusClosed;
      default:
        return statusDraft;
    }
  }
}
