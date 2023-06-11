import 'package:flutter_todo/data/database.dart';
import 'package:get/get.dart';
import 'package:flutter_todo/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {}

  RxList<Task> taskList = <Task>[].obs;

  Future<void> addTask(Task task) async {
    print("Adding New Task");
    final id = await DatabaseHelder.insertTask(task);
    print(' Task Added With Id $id ');
  }

  void getTasks() async {
    print("Getting All Tasks");
    List<Map<String, dynamic>> tasks = await DatabaseHelder.getTasks();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)));
    print('Total Tasks ${taskList.length}');
  }

  void deleteTask(int taskId) async {
    print("Deleting Task");
    final id = await DatabaseHelder.deleteTask(taskId);
    print('Task with Id $id is Deleted');
    getTasks();
  }

  void markTaskCompleted(int taskId) async {
    print("Updating Task");
    final id = await DatabaseHelder.updateTask(taskId);
    print('Task with id $id is Updated');
    getTasks();
  }
}
