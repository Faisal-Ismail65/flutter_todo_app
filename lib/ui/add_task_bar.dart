import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/controllers/task_controller.dart';
import 'package:flutter_todo/models/task.dart';
import 'package:flutter_todo/ui/theme.dart';
import 'package:flutter_todo/ui/widgets/button.dart';
import 'package:flutter_todo/ui/widgets/input_field.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String startTime = DateFormat('hh:mm a').format(DateTime.now());
  String endTime = DateFormat('hh:mm a').format(
    DateTime.now().add(
      const Duration(hours: 2),
    ),
  );

  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Montly',
  ];

  String selectedRepeat = 'None';

  int selectedRemind = 5;

  int selectedColor = 0;
  DateTime selectedDate = DateTime.now();

  void pickTime({required bool isStartTime}) async {
    Get.bottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      )),
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.32,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: isStartTime
                    ? selectedDate
                    : selectedDate.add(const Duration(hours: 2)),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    isStartTime
                        ? startTime = DateFormat('hh:mm a').format(newDate)
                        : endTime = DateFormat('hh:mm a').format(newDate);
                    print(startTime);
                    print(endTime);
                  });
                },
                use24hFormat: false,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.time,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickDate() async {
    Get.bottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        topLeft: Radius.circular(30),
      )),
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.32,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                },
                use24hFormat: true,
                minuteInterval: 1,
                mode: CupertinoDatePickerMode.date,
              ),
            ),
          ],
        ),
      ),
    );
  }

  addTaskToDb() async {
    print(startTime);
    print(endTime);
    print(DateFormat.yMd().format(selectedDate));
    final task = Task(
      title: _titleController.text,
      note: _noteController.text,
      date: DateFormat.yMd().format(selectedDate),
      startTime: startTime,
      endTime: endTime,
      remind: selectedRemind,
      color: selectedColor,
      repeat: selectedRepeat,
      isCompleted: 0,
    );
    await taskController.addTask(task);
  }

  validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All Fields are Required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios,
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Add Task',
                style: headingStyle,
              ),
              MyInputField(
                title: 'Title',
                hint: 'Enter Your Title',
                controller: _titleController,
              ),
              MyInputField(
                title: 'Note',
                hint: 'Enter Your Note',
                controller: _noteController,
              ),
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(selectedDate),
                widget: IconButton(
                  onPressed: pickDate,
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: startTime,
                      widget: IconButton(
                        onPressed: () => pickTime(isStartTime: true),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: endTime,
                      widget: IconButton(
                        onPressed: () => pickTime(isStartTime: false),
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: 'Remind',
                hint: '$selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  items: remindList.map((e) {
                    return DropdownMenuItem(
                      value: e.toString(),
                      child: Text(
                        '$e minutes early',
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: 'Repeat',
                hint: selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subTitleStyle,
                  items: repeatList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRepeat = value!;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Color',
                        style: titleStyle,
                      ),
                      Wrap(
                        children: List<Widget>.generate(
                          3,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, top: 5),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: index == 0
                                      ? primaryClr
                                      : index == 1
                                          ? pinkClr
                                          : yellowClr,
                                  child: selectedColor == index
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  MyButton(
                    label: 'Create Task',
                    onTap: validateData,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
