import 'package:flutter/material.dart';
import 'todo_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, value, child) {
        return MaterialApp(
          title: 'Todo List',
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          // theme: ThemeData(
          //   primarySwatch: Colors.blue,
          // ),
          home: const TodoListScreen(),
        );
      },
    );
  }
}
