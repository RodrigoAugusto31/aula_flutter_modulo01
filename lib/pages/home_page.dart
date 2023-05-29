import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/tasks_provider.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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

    void loadData() {
      db.loadData();
    }


    WidgetsBinding.instance.addPostFrameCallback((context) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
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