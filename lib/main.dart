import 'package:desenvolvimento_flutter_modulo_01/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'Provider/tasks_provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => ToDoProvider(),
        child: const HomePage(),
      ),
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}