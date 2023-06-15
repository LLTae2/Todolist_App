import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_project/todo_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;

  const MyApp({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: TodoListScreen(),
    );
  }
}
