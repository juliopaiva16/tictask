import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'models/task.dart';
import 'models/tag.dart';
import 'models/time_point.dart';
import 'models/subtask.dart';
import 'views/task_list_screen.dart';
import 'views/splash_screen.dart';


final ThemeData ticTaskTheme = ThemeData(
  // Cores principais
  primaryColor: const Color(0xFFFFFFFF),        // Fundo branco do ícone
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  canvasColor: const Color(0xFFFFFFFF),

  // Cor de destaque
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CAF50), // Verde-limão do checkmark
    primary: const Color(0xFF4CAF50),
    onPrimary: Colors.white,
    secondary: const Color(0xFF4CAF50),
    surface: Colors.white,
    onSurface: const Color(0xFF0D1B2A),
    brightness: Brightness.light,
  ),

  // Texto
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0D1B2A), // texto azul escuro
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      color: Color(0xFF2E3A59), // cinza escuro para texto secundário
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Color(0xFF0D1B2A),
    ),
  ),

  // Botões e interações
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CAF50), // verde-limão
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF0D1B2A),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Color(0xFF0D1B2A),
    ),
  ),

  // Ícones
  iconTheme: const IconThemeData(
    color: Color(0xFF4CAF50), // verde-limão para ícones destacados
  ),

  // Cursor do texto, seleção
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF4CAF50),
    selectionColor: Color(0x334CAF50), // mais suave em fundo claro
    selectionHandleColor: Color(0xFF4CAF50),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init(
      Platform.isMacOS || Platform.isLinux || Platform.isWindows
        ? './hive'
        : 'hive'
    )
    ..registerAdapter(TagAdapter())
    ..registerAdapter(TimePointAdapter())
    ..registerAdapter(SubtaskAdapter())
    ..registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Tag>('tags');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TicTask - Task Time Manager',
      theme: ticTaskTheme,
      home: const AppWrapper(),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool _isInitialized = false;

  void _onInitializationComplete() {
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SplashScreen(
        onInitializationComplete: _onInitializationComplete,
      );
    }

    return TaskListScreen(
      availableTags: [
        Tag(id: '1', name: 'Development', iconCodePoint: Icons.code.codePoint, colorValue: Colors.blue.toARGB32()),
        Tag(id: '2', name: 'Meeting', iconCodePoint: Icons.people.codePoint, colorValue: Colors.green.toARGB32()),
        Tag(id: '3', name: 'Research', iconCodePoint: Icons.search.codePoint, colorValue: Colors.orange.toARGB32()),
        Tag(id: '4', name: 'Testing', iconCodePoint: Icons.bug_report.codePoint, colorValue: Colors.red.toARGB32()),
      ],
    );
  }
}
