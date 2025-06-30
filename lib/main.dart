import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'models/tag.dart';
import 'models/time_point.dart';
import 'models/subtask.dart';
import 'utils/hive_utils.dart';
import 'utils/theme_provider.dart';
import 'views/task_list_screen.dart';
import 'views/splash_screen.dart';

// Light theme
final ThemeData ticTaskLightTheme = ThemeData(
  // Main colors
  primaryColor: const Color(0xFFFFFFFF), // White background of the icon
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  canvasColor: const Color(0xFFFFFFFF),

  // Accent color
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4CAF50), // Lime green for the checkmark
    primary: const Color(0xFF4CAF50),
    onPrimary: Colors.white,
    secondary: const Color(0xFF4CAF50),
    surface: Colors.white,
    onSurface: const Color(0xFF0D1B2A),
    brightness: Brightness.light,
  ),

  // Text
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0D1B2A), // dark blue text
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      color: Color(0xFF2E3A59), // dark gray for secondary text
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Color(0xFF0D1B2A),
    ),
  ),

  // Buttons and interactions
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4CAF50), // lime green
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  // Icons
  iconTheme: const IconThemeData(
    color: Color(0xFF4CAF50), // lime green for highlighted icons
  ),

  // Text cursor, selection
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF4CAF50),
    selectionColor: Color(0x334CAF50), // softer on light background
    selectionHandleColor: Color(0xFF4CAF50),
  ),
);

// Dark theme
final ThemeData ticTaskDarkTheme = ThemeData(
  // Main colors
  primaryColor: const Color(0xFF1F1F1F), // Dark background
  scaffoldBackgroundColor: const Color(0xFF121212),
  canvasColor: const Color(0xFF121212),

  // Accent color
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF66BB6A), // Lighter lime green for dark theme
    primary: const Color(0xFF66BB6A),
    onPrimary: Colors.black,
    secondary: const Color(0xFF66BB6A),
    surface: const Color(0xFF1F1F1F),
    onSurface: Colors.white,
    brightness: Brightness.dark,
  ),

  // Texto
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16,
      color: Color(0xFFD1D1D1), // light gray for secondary text
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  // Buttons and interactions
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF66BB6A), // lighter lime green
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Colors.white,
    ),
  ),

  // Icons
  iconTheme: const IconThemeData(
    color: Color(0xFF66BB6A), // lighter lime green for highlighted icons
  ),

  // Text cursor, selection
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF66BB6A),
    selectionColor: Color(0x3366BB6A), // softer on dark background
    selectionHandleColor: Color(0xFF66BB6A),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init(
      Platform.isMacOS || Platform.isLinux || Platform.isWindows
          ? './hive'
          : 'hive',
    )
    ..registerAdapter(TagAdapter())
    ..registerAdapter(TimePointAdapter())
    ..registerAdapter(SubtaskAdapter())
    ..registerAdapter(TaskAdapter());

  try {
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Tag>('tags');
    await Hive.openBox('app_settings'); // Box for app settings
  } catch (e) {
    print('Error opening Hive boxes: $e');
    print('Clearing database and retrying...');

    // Try to close any open boxes first
    await Hive.close();

    // Delete the Hive database
    await HiveUtils.deleteHiveFolder();

    // Reinitialize Hive
    Hive
      ..init(
        Platform.isMacOS || Platform.isLinux || Platform.isWindows
            ? './hive'
            : 'hive',
      )
      ..registerAdapter(TagAdapter())
      ..registerAdapter(TimePointAdapter())
      ..registerAdapter(SubtaskAdapter())
      ..registerAdapter(TaskAdapter());

    // Try opening the boxes again
    await Hive.openBox<Task>('tasks');
    await Hive.openBox<Tag>('tags');
    await Hive.openBox('app_settings');
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TicTask - Task Time Manager',
      theme: ticTaskLightTheme,
      darkTheme: ticTaskDarkTheme,
      themeMode: themeProvider.themeMode,
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
  final List<Tag> _initialTags = [
    Tag(
      id: '1',
      name: 'Development',
      iconCodePoint: Icons.code.codePoint,
      colorValue: Colors.blue.value,
    ),
    Tag(
      id: '2',
      name: 'Meeting',
      iconCodePoint: Icons.people.codePoint,
      colorValue: Colors.green.value,
    ),
    Tag(
      id: '3',
      name: 'Research',
      iconCodePoint: Icons.search.codePoint,
      colorValue: Colors.orange.value,
    ),
    Tag(
      id: '4',
      name: 'Testing',
      iconCodePoint: Icons.bug_report.codePoint,
      colorValue: Colors.red.value,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize tags if they don't exist
    final tagBox = Hive.box<Tag>('tags');
    if (tagBox.isEmpty) {
      for (final tag in _initialTags) {
        await tagBox.add(tag);
      }
    }
  }

  void _onInitializationComplete() {
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SplashScreen(onInitializationComplete: _onInitializationComplete);
    }

    return TaskListScreen();
  }
}
