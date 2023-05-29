import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';

class ToDoProvider with ChangeNotifier {
  final _myBox = Hive.box('mybox');
  List<List<dynamic>> toDoList = [];

  void createInitialData() {
    toDoList = [
      ["Fazer compras", false, "-23.8965422 : -38.3306205"],
      ["Abastecer o carro", false, "-53.9975523 : -18.4307405"],
    ];
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST") ?? [];
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }

  Future<String> getLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return "";
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return "";
    }
    locationData = await location.getLocation();
    return "${locationData.latitude} : ${locationData.longitude}";
  }

  void checkBoxChanged(bool? value, int index) {
    toDoList[index][1] = !toDoList[index][1];
    updateDataBase();
    notifyListeners();
  }

  void saveNewTask(String taskName, TextEditingController controller) async {
    String location = await getLocation();
    toDoList.add([taskName, false, location]);
    controller.clear();
    updateDataBase();
    notifyListeners();
  }

  void deleteTask(int index) {
    toDoList.removeAt(index);
    updateDataBase();
    notifyListeners();
  }

  void updateTask(int index, String taskName, TextEditingController controller) {
    toDoList[index][0] = taskName;
    controller.clear();
    updateDataBase();
    notifyListeners();
  }
}