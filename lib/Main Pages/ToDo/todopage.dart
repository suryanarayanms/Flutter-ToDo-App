import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_app/widgets/navigation_drawer_widget.dart';
import 'package:todo_app/Main%20Pages/ToDo/taskpage.dart';
import 'package:todo_app/Main%20Pages/tasktile.dart';
import 'package:todo_app/widgets/database.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({
    Key? key,
  }) : super(key: key);

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime timeBackPressed = DateTime.now();
  final DatabaseDB _db = DatabaseDB();
  List<TaskCard> task = [];
  bool isLoading = true;

  Widget buildEffect() {
    return Center(
      child: LoadingAnimationWidget.prograssiveDots(
        size: 30,
        color: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getEffect();
  }

  getEffect() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1240), () {});
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.blue[400],
      key: _scaffoldKey,
      drawer: const NavigationDrawerWidget(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 2,
      body: WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(milliseconds: 900);
          timeBackPressed = DateTime.now();
          if (isExitWarning) {
            const message = 'Press back again to exit';
            Fluttertoast.showToast(msg: message, fontSize: 18);
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.inkDrop(
                  size: 30,
                  color: Colors.white,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 95),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: GestureDetector(
                              onTap: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                              child: const SizedBox(
                                height: 30,
                                child: Image(
                                  image: AssetImage(
                                    'assets/nav_icon_white.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'To-Do',
                          style: GoogleFonts.spartan(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: FutureBuilder(
                                    future: _db.getTasks(),
                                    builder: (context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return ScrollConfiguration(
                                          behavior: NoGlowBehavior(),
                                          child: DelayedDisplay(
                                            delay: const Duration(
                                                milliseconds: 300),
                                            fadeIn: true,
                                            slidingBeginOffset:
                                                const Offset(0, 0),
                                            child: ListView.builder(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  if (isLoading) {
                                                    return buildEffect();
                                                  } else {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    TaskPage(
                                                              task: snapshot
                                                                  .data[index],
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          setState(() {});
                                                        });
                                                      },
                                                      child: TaskCard(
                                                        title: snapshot
                                                            .data![index]
                                                            ?.title,
                                                        desc: snapshot
                                                            .data![index]
                                                            ?.description,
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: LoadingAnimationWidget
                                              .prograssiveDots(
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            bottom: 37,
                            right: 20,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const TaskPage(
                                            task: null,
                                          )),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: 60.0,
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
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
                                margin: const EdgeInsets.only(
                                    right: 10, bottom: 20),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ));
}

class CheckBoxWidget extends StatelessWidget {
  const CheckBoxWidget({Key? key, this.text, @required this.isDone})
      : super(key: key);
  final dynamic text;
  final dynamic isDone;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                color: isDone ? Colors.blue[400] : Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: isDone ? null : Border.all(color: Colors.blue)),
            child: Icon(
              isDone ? Icons.check : Icons.check_box_outline_blank,
              color: isDone ? Colors.white : Colors.transparent,
              size: 20,
            ),
          ),
          Flexible(
            child: Text(text ?? "(UnNamed Todo Widget)",
                style: GoogleFonts.spartan(
                  textStyle: TextStyle(
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      fontWeight: isDone ? FontWeight.bold : null,
                      color:
                          isDone ? Colors.blue[400] : const Color(0XFF868290)),
                )),
          ),
        ],
      ),
    );
  }
}
