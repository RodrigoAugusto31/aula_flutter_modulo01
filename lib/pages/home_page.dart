import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Provider/tasks_provider.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<ToDoProvider>(context);
    final controller = TextEditingController();

    Future<void> createNewTask() async {
      showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: controller,
            onSave: (taskName) => db.saveNewTask(taskName, controller),
            onCancel: () => Navigator.of(context).pop(),
          );
        },
      );
    }

    Future<void> openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

    void loadData() {
      db.loadData();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });

    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('Lista de tarefas'),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Número de tarefas: ${db.toDoList.length}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: createNewTask,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: openCamera,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: Column(
        children: [
          if (imageFile != null) ...[
            Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: FileImage(imageFile!),
        ),
        const SizedBox(height: 8),
        Text('Usuário:'),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Digite o nome',
          ),
          // Adicione um controlador se desejar acessar o valor digitado posteriormente.
        ),
      ],
    ),
  ),
  const Divider(),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  location: db.toDoList[index][2],
                  onChanged: (value) => db.checkBoxChanged(value, index),
                  editFunction: (context) => updateTask(context, db, index),
                  deleteFunction: (context) => db.deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateTask(BuildContext context, ToDoProvider db, int index) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: controller,
          onSave: (taskName) => db.updateTask(index, taskName, controller),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}