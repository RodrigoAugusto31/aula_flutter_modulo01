import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class ToDoProvider with ChangeNotifier {
  final _myBox = Hive.box('mybox');
  List<List<dynamic>> toDoList = [];

  void createInitialData() {
    toDoList = [
      ["Fazer compras", false, "São Paulo"],
      ["Abastecer o carro", false, "Campinas"],
    ];
  }

  void loadData() {
    final savedList = _myBox.get("TODOLIST");
    if (savedList != null) {
      toDoList = List<List<dynamic>>.from(savedList);
    } else {
      createInitialData();
    }
    notifyListeners();
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
  final cityName = await getCityName(locationData.latitude!, locationData.longitude!);
  return cityName;
  }

  Future<String> getCityName(double latitude, double longitude) async {
  final apiKey = '997e0b321b18947f5168698878d11f08';
  final url = 'http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';
  
  final response = await http.get(Uri.parse(url));
  
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    final cityName = json['name'];
    return cityName;
  } else {
    throw Exception('Failed to get city name');
  }
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