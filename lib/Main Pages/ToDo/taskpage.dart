import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Main%20Pages/ToDo/todopage.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/widgets/database.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key, this.title, this.desc, this.task})
      : super(key: key);
  final dynamic title;
  final dynamic desc;
  final Task? task;
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  dynamic currentFocus;

  unfocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  int _taskId = 0;
  dynamic _taskTitle = "";
  dynamic _taskDescription = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;

  bool _contentVisible = false;

  final DatabaseDB _db = DatabaseDB();
  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task?.title;
      _taskDescription = widget.task?.description;
      _taskId = widget.task?.id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_taskDescription == "") {
          await _db.deleteTask(_taskId);
          Navigator.pop(context);
        }
        return true;
      },
      child: GestureDetector(
        onTap: unfocus,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40, left: 20, right: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.keyboard_arrow_left_sharp,
                                  color: Colors.black,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: Visibility(
                                  visible: _contentVisible,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (_taskId != 0) {
                                        await _db.deleteTask(_taskId);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[400],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.save_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 2,
                                child: Visibility(
                                  visible: _contentVisible,
                                  child: GestureDetector(
                                    // onTap: () async {
                                    // if (_taskId != 0 ||
                                    //     _taskDescription == "") {
                                    //   await _db.deleteTask(_taskId);
                                    //   Navigator.pop(context);
                                    // }
                                    // },
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title:
                                                    const Text("Delete Note"),
                                                content: const Text(
                                                    "This note will be deleted permanently"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text("CANCEL")),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (_taskId != 0 ||
                                                          _taskDescription ==
                                                              "") {
                                                        await _db.deleteTask(
                                                            _taskId);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    const TodoPage()));
                                                      }
                                                    },
                                                    child: const Text(
                                                      "DELETE",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  )
                                                ],
                                              ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, left: 10.0),
                                      child: Container(
                                        width: 50.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.delete_forever_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 35.0, top: 20.0),
                          child: Expanded(
                            child: TextField(
                              autofocus: true,
                              focusNode: _titleFocus,
                              // onTap: unfocus,
                              onSubmitted: (value) async {
                                if (value != '') {
                                  if (widget.task == null) {
                                    Task _newTask = Task(title: value);
                                    _taskId = await _db.insertTask(_newTask);
                                    setState(() {
                                      _contentVisible = true;
                                      _taskTitle = value;
                                    });
                                  } else {
                                    await _db.updateTaskTitle(_taskId, value);
                                    _taskTitle = value;
                                  }

                                  _descriptionFocus.requestFocus();
                                }
                              },
                              controller: TextEditingController()
                                ..text = _taskTitle
                                ..selection = TextSelection.collapsed(
                                    offset: _taskTitle.length),
                              decoration: const InputDecoration(
                                hintText: 'Enter the title',
                                border: InputBorder.none,
                              ),
                              style: GoogleFonts.spartan(
                                  textStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: _contentVisible,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              autofocus: true,
                              focusNode: _descriptionFocus,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              // onTap: unfocus,
                              onSubmitted: (value) async {
                                if (value != '') {
                                  if (_taskId != 0) {
                                    await _db.updateDescription(_taskId, value);
                                    _taskDescription = value;
                                  }
                                }
                              },
                              controller: TextEditingController()
                                ..text = _taskDescription
                                ..selection = TextSelection.collapsed(
                                    offset: _taskDescription.length),
                              decoration: InputDecoration(
                                hintText: "Start typing your stories here...",
                                hintStyle: GoogleFonts.spartan(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w300)),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                              ),
                              style: GoogleFonts.spartan(
                                  textStyle: const TextStyle(
                                      decoration: TextDecoration.none)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  Widget buildViewportchrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
