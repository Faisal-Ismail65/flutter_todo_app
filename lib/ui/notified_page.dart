import 'package:flutter/material.dart';
import 'package:flutter_todo/models/task.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final Task task;
  const NotifiedPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          task.title!,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        height: 400,
        width: 300,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.white : Colors.grey[400],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          task.note!,
        ),
      ),
    );
  }
}
