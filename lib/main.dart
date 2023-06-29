import 'package:desenvolvimento_flutter_modulo_01/pages/home_page.dart';
import 'package:desenvolvimento_flutter_modulo_01/pages/sign_in_page.dart';
import 'package:desenvolvimento_flutter_modulo_01/routes/routes_path.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'Provider/tasks_provider.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('mybox');

   WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.yellow),
    initialRoute: RoutePaths.SIGN_IN_SCREEN,
    routes: {
      RoutePaths.SIGN_IN_SCREEN: (context) => ChangeNotifierProvider(
        create: (context) => ToDoProvider(),
        child: SignInScreen(),
      ),
      RoutePaths.HOME_PAGE: (context) => ChangeNotifierProvider(
        create: (context) => ToDoProvider(),
        child: HomePage(),
      ),
    },
  );
}
}