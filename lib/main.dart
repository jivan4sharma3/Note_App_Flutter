import 'package:flutter/material.dart';
import 'package:notesapp/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Changed from HomeScreen to SplashScreen
      debugShowCheckedModeBanner: false,
    );
  }
}

// Colors
class AppColors {
  static const background = Color(0xFFFAF9F6);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF2D2A26);
  static const accent = Color(0xFFE8846B);
  static const subtleText = Color(0xFF8A8580);
  static const divider = Color(0xFFEDEAE4);

  static const List<Color> noteColors = [
    Color(0xFFFFFFFF), // white
    Color(0xFFFFF3E0), // peach
    Color(0xFFE8F5E9), // mint
    Color(0xFFE3F2FD), // sky
    Color(0xFFFCE4EC), // blush
    Color(0xFFF3E5F5), // lavender
    Color(0xFFFFFDE7), // butter
  ];
}

class Note {
  final int? id;
  final String title;
  final String content;
  final int color;
  final DateTime updatedAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.color = 0,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Note copyWith({
    int? id,
    String? title,
    String? content,
    int? color,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
