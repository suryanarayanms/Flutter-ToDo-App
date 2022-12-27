// import 'package:ToDo/widget/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/db/notes_database.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/page/edit_note_page.dart';
import 'package:todo_app/page/note_detail_page.dart';
import 'package:todo_app/widget/navigation_drawer_widget.dart';
import 'package:todo_app/widget/note_card_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Provider/toggletheme.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime timeBackPressed = DateTime.now();
  bool isLoading = false;

  late bool theee;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawerWidget(),
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        drawerEdgeDragWidth: MediaQuery.of(context).size.width / 4,
        backgroundColor: context.watch<ChangeTheme>().currenttheme
            ? Colors.blue[400]
            : const Color.fromRGBO(30, 30, 30, 225),
        body: WillPopScope(
          onWillPop: () async {
            final difference = DateTime.now().difference(timeBackPressed);
            final isExitWarning =
                difference >= const Duration(milliseconds: 1200);
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 95),
                child: GestureDetector(
                  onTap: () => {
                    _scaffoldKey.currentState?.openDrawer(),
                    // Snackbar().showFlushbar(
                    //     context: context, message: "Trending  Frame Uploaded")
                  },
                  // _scaffoldKey.currentState?.openDrawer(),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: SizedBox(
                          height: 30,
                          child: Image(
                            image: AssetImage(
                              'assets/nav_icon_white.png',
                            ),
                          ),
                        ),
                      ),
                      const Text('Notes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          )),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: GestureDetector(
                            onTap: () => {
                                  context.read<ChangeTheme>().toggletheme(),
                                },
                            child: Icon(
                              context.watch<ChangeTheme>().currenttheme
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.watch<ChangeTheme>().currenttheme
                          ? Colors.white
                          : const Color.fromRGBO(30, 30, 30, 40),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : notes.isEmpty
                              ? Text(
                                  'Create New Notes',
                                  style: TextStyle(
                                      color: context
                                              .watch<ChangeTheme>()
                                              .currenttheme
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 24),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, left: 12, right: 12, bottom: 0),
                                  child: buildNotes(),
                                ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 40.0, bottom: 60),
          child: GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddEditNotePage()),
              );

              refreshNotes();
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: context.watch<ChangeTheme>().currenttheme
                          ? Colors.blue
                          : Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  height: 50,
                  width: 50,
                ),
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: const EdgeInsets.only(top: 20, right: 5, left: 5),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => const StaggeredTile.fit(4),
        crossAxisCount: 4,
        physics: const BouncingScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}
