import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_todo/controllers/task_controller.dart';
import 'package:flutter_todo/models/task.dart';
import 'package:flutter_todo/services/notification_service.dart';
import 'package:flutter_todo/services/theme_services.dart';
import 'package:flutter_todo/ui/add_task_bar.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:flutter_todo/ui/widgets/bottom_sheet_button.dart';
import 'package:flutter_todo/ui/widgets/button.dart';
import 'package:flutter_todo/ui/widgets/task_tile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotifyHelper notifyHelper = NotifyHelper();
  final TaskController taskController = Get.put(TaskController());

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notifyHelper.initializeNotification();
    taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            ThemeServices().switchTheme();
            setState(() {});
            print(Get.isDarkMode);
            notifyHelper.displayNotification(
              title: 'Theme Changed',
              body: Get.isDarkMode
                  ? "Activated Light Theme"
                  : "Activated Dark Theme",
            );
            notifyHelper.scheduleNotification(
                3, 34, Task(id: 1, title: 'Hello', note: "hello note"));
          },
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profilepic.jpg'),
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                    Text(
                      'Today',
                      style: headingStyle,
                    ),
                  ],
                ),
                MyButton(
                  label: '+ Add Task',
                  onTap: () async {
                    await Get.to(() => const AddTaskPage());
                    taskController.getTasks();
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              dayTextStyle: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              monthTextStyle: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
              onDateChange: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: taskController.taskList.length,
                itemBuilder: (context, index) {
                  final task = taskController.taskList[index];
                  if (task.repeat == 'Daily') {
                    DateTime date = DateFormat.jm().parse(task.startTime!);
                    final myTime = DateFormat('HH:mm').format(date);
                    int hour = int.parse(myTime.split(":")[0]);
                    int minutes = int.parse(myTime.split(":")[1]);
                    notifyHelper.scheduleNotification(hour, minutes, task);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      padding: const EdgeInsets.only(top: 4),
                                      height: task.isCompleted == 1
                                          ? MediaQuery.of(context).size.height *
                                              0.24
                                          : MediaQuery.of(context).size.height *
                                              0.32,
                                      color: Get.isDarkMode
                                          ? darkGreyClr
                                          : Colors.white,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 6,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Get.isDarkMode
                                                  ? Colors.grey[600]
                                                  : Colors.grey[300],
                                            ),
                                          ),
                                          const Spacer(),
                                          task.isCompleted == 1
                                              ? Container()
                                              : BottomSheetButton(
                                                  label: 'Task Completed',
                                                  onTap: () {
                                                    taskController
                                                        .markTaskCompleted(
                                                      task.id!,
                                                    );
                                                    Get.back();
                                                  },
                                                  clr: primaryClr,
                                                ),
                                          BottomSheetButton(
                                            label: 'Delete Task',
                                            onTap: () {
                                              taskController
                                                  .deleteTask(task.id!);
                                              Get.back();
                                            },
                                            clr: Colors.red[300]!,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          BottomSheetButton(
                                            label: 'Close',
                                            onTap: () {
                                              Get.back();
                                            },
                                            isClose: true,
                                            clr: Colors.red[300]!,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: TaskTile(task: task),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (task.date ==
                      DateFormat.yMd().format(selectedDate)) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      child: SlideAnimation(
                        child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      padding: const EdgeInsets.only(top: 4),
                                      height: task.isCompleted == 1
                                          ? MediaQuery.of(context).size.height *
                                              0.24
                                          : MediaQuery.of(context).size.height *
                                              0.32,
                                      color: Get.isDarkMode
                                          ? darkGreyClr
                                          : Colors.white,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 6,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Get.isDarkMode
                                                  ? Colors.grey[600]
                                                  : Colors.grey[300],
                                            ),
                                          ),
                                          const Spacer(),
                                          task.isCompleted == 1
                                              ? Container()
                                              : BottomSheetButton(
                                                  label: 'Task Completed',
                                                  onTap: () {
                                                    taskController
                                                        .markTaskCompleted(
                                                      task.id!,
                                                    );
                                                    Get.back();
                                                  },
                                                  clr: primaryClr,
                                                ),
                                          BottomSheetButton(
                                            label: 'Delete Task',
                                            onTap: () {
                                              taskController
                                                  .deleteTask(task.id!);
                                              Get.back();
                                            },
                                            clr: Colors.red[300]!,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          BottomSheetButton(
                                            label: 'Close',
                                            onTap: () {
                                              Get.back();
                                            },
                                            isClose: true,
                                            clr: Colors.red[300]!,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: TaskTile(task: task),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
