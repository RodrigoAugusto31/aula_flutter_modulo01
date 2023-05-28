import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  final String taskName;
  final String location;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;
  Function(BuildContext)? editFunction;

   // ignore: use_key_in_widget_constructors
   ToDoTile({
    Key? key,
    required this.taskName,
    required this.location,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
  });

  @override
 Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
    child: Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: editFunction,
            icon: Icons.edit,
            backgroundColor: const Color.fromARGB(255, 11, 148, 22),
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: deleteFunction,
            icon: Icons.delete,
            backgroundColor: const Color.fromARGB(255, 219, 38, 38),
            borderRadius: BorderRadius.circular(12),
          )
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              activeColor: Colors.black,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName,
                    style: TextStyle(
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Location: $location',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}