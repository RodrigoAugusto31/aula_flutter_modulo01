import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Provider/tasks_provider.dart';
import '../routes/routes_path.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  File? imageFile;

  final String _imageBoxKey = 'imageBox';
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    await Hive.openBox(_imageBoxKey);
    final box = Hive.box(_imageBoxKey);
    imagePath = box.get('imagePath') as String?;
    setState(() {});
  }

  Future<void> _saveImageToHive(String imagePath) async {
    final box = Hive.box(_imageBoxKey);
    await box.put('imagePath', imagePath);
  }

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
            onCancel: () => Navigator.of(context).pop(RoutePaths.HOME_PAGE),
          );
        },
      );
    }

    Future<void> openCamera() async {
  final pickedFile = await picker.pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    setState(() {
      imageFile = File(pickedFile.path);
      imagePath = pickedFile.path;
    });
    await _saveImageToHive(imagePath!);
  }
}

    void loadData() {
  final box = Hive.box(_imageBoxKey);
  imagePath = box.get('imagePath') as String?;
  setState(() {});
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
       bottomNavigationBar: BottomAppBar(
  child: Container(
    height: kToolbarHeight,
    color: Colors.yellow[200], 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: ElevatedButton(
            onPressed: createNewTask,
            child: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.yellow[200], 
              shape: CircleBorder(), 
            ),
          ),
        ),
        SizedBox(width: 1),
        Container(
          child: ElevatedButton(
            onPressed: openCamera,
            child: Icon(Icons.camera_alt),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.yellow[200], 
              shape: CircleBorder(), 
            ),
          ),
        ),
      ],
    ),
  ),
),
      body: Column(
      children: [
        if (imageFile != null || imagePath != null) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!)
                      : FileImage(File(imagePath!)),
                ),
                const SizedBox(height: 5),
                const Text('Foto de Usuário'),
                const SizedBox(height: 10),
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
          const SizedBox(height: 16), 
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
          onCancel: () => Navigator.of(context).pop(RoutePaths.HOME_PAGE),
        );
      },
    );
  }
}