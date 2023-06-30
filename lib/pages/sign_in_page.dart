import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../routes/routes_path.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Usuário autenticado."),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pushReplacementNamed(RoutePaths.HOME_PAGE);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$e"),
        duration: const Duration(seconds: 2),
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "e-mail"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "senha"),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => {
                      login()
                    },
                    child: const Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}