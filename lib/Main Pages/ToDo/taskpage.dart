import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Main%20Pages/ToDo/todopage.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/widgets/database.dart';
import 'package:todo_app/widgets/flushbar.dart';

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
  int _taskId = 0;
  dynamic _taskTitle = "";
  dynamic _taskDescription = " ";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

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
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(
                                Icons.keyboard_arrow_left_sharp,
                                color: Colors.black,
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              autofocus: true,
                              focusNode: _titleFocus,
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
                                hintText: 'Enter the text',
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
                        ],
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
                          onSubmitted: (value) async {
                            if (value != '') {
                              if (_taskId != 0) {
                                await _db.updateDescription(_taskId, value);
                                _taskDescription = value;
                              }
                            }
                            if (_taskDescription != '') {
                              _todoFocus.requestFocus();
                            } else {
                              return Snackbar().showFlushbar(
                                  context: context,
                                  message: "Provide A Description MF");
                            }
                          },
                          controller: TextEditingController()
                            ..text = _taskDescription
                            ..selection = TextSelection.collapsed(
                                offset: _taskDescription.length),
                          decoration: InputDecoration(
                            hintText: "Description comes over here",
                            hintStyle: GoogleFonts.spartan(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w300)),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          style: GoogleFonts.spartan(
                              textStyle: const TextStyle(
                                  decoration: TextDecoration.none)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _contentVisible,
                      child: FutureBuilder(
                        future: _db.getTodo(_taskId),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (snapshot.data[index].isDone == 0) {
                                          await _db.updateTodo(
                                              snapshot.data[index].id, 1);
                                        } else {
                                          await _db.updateTodo(
                                              snapshot.data[index].id, 0);
                                        }
                                        setState(() {});
                                      },
                                      child: CheckBoxWidget(
                                        text: snapshot.data[index].title,
                                        isDone: snapshot.data[index].isDone == 0
                                            ? false
                                            : true,
                                      ),
                                    );
                                  }),
                            );
                          } else {
                            return Container(color: Colors.black);
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: _contentVisible,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6.0),
                                  border: Border.all(color: Colors.blue)),
                              child: const Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.transparent,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                focusNode: _todoFocus,
                                controller: TextEditingController()..text = '',
                                onSubmitted: (value) async {
                                  if (value != "") {
                                    if (_taskId != 0) {
                                      DatabaseDB _db = DatabaseDB();
                                      Todo _newTodo = Todo(
                                          title: value,
                                          isDone: 0,
                                          taskId: _taskId);
                                      await _db.insertTodo(_newTodo);
                                      setState(() {});
                                      _todoFocus.requestFocus();
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Write down your TODO's",
                                    hintStyle: GoogleFonts.spartan(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue)),
                                    border: InputBorder.none),
                                style: GoogleFonts.spartan(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blue)),
                                cursorColor: Colors.blue[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _contentVisible,
                  child: Positioned(
                    bottom: 57,
                    right: 40,
                    child: GestureDetector(
                      onTap: () async {
                        if (_taskId != 0) {
                          await _db.deleteTask(_taskId);
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, bottom: 20),
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEC407A),
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
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
              ],
            ),
          ],
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
