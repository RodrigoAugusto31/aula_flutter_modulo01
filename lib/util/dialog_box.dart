import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSave;
  final VoidCallback onCancel;

  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  DialogBox({
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
   Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[200],
      content: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Insira sua tarefa",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    onSave(controller.text);
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text("Salvar"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    onCancel();
                    //Navigator.pop(context); // Close the dialog
                  },
                  child: const Text("Cancelar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}