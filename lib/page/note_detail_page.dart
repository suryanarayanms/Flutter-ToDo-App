import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/db/notes_database.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/page/edit_note_page.dart';
import 'package:todo_app/page/notes_page.dart';

import '../Provider/toggletheme.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.watch<ChangeTheme>().currenttheme
            ? Colors.white
            : const Color.fromRGBO(30, 30, 30, 40),
        appBar: AppBar(
          toolbarHeight: 100,
          leading: GestureDetector(
            onTap: () => {Navigator.of(context).pop()},
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 40.0),
              child: Icon(
                Icons.keyboard_arrow_left_sharp,
                color: context.watch<ChangeTheme>().currenttheme
                    ? Colors.black
                    : Colors.white,
                size: 40,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 20),
              child: editButton(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 20),
              child: deleteButton(),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 30, right: 30, bottom: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                      child: Row(
                        children: [
                          Text(
                            note.title,
                            style: TextStyle(
                              color: context.watch<ChangeTheme>().currenttheme
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          Text(
                            note.description,
                            style: TextStyle(
                                color: context.watch<ChangeTheme>().currenttheme
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget editButton() => Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Visibility(
          visible: true,
          child: GestureDetector(
            onTap: () async {
              if (isLoading) return;

              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddEditNotePage(note: note),
              ));

              refreshNote();
            },
            child: Container(
              width: 70.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: context.watch<ChangeTheme>().currenttheme
                    ? Colors.blue[400]
                    : Colors.black,
                borderRadius: BorderRadius.circular(15.0),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.2),
                //     spreadRadius: 1,
                //     blurRadius: 10,
                //     offset: const Offset(0, 2),
                //   )
                // ],
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget deleteButton() => GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Delete Note"),
                  content: const Text("This note will be deleted permanently"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("CANCEL")),
                    TextButton(
                      onPressed: () async {
                        await NotesDatabase.instance.delete(widget.noteId);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const NotesPage()));
                      },
                      child: const Text(
                        "DELETE",
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                )),
        child: Container(
          width: 70.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: context.watch<ChangeTheme>().currenttheme
                ? Colors.red[400]
                : Colors.red,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),

            onPressed: () async {
              await NotesDatabase.instance.delete(widget.noteId);

              Navigator.of(context).pop();
            },
            // showDialog(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //           title: const Text("Delete Note"),
            //           content:
            //               const Text("This note will be deleted permanently"),
            //           actions: [
            //             TextButton(
            //                 onPressed: () => Navigator.pop(context),
            //                 child: const Text("CANCEL")),
            //             TextButton(
            //               onPressed: () async {
            //                 await NotesDatabase.instance
            //                     .delete(widget.noteId);

            //                 Navigator.of(context).pop();
            //               },
            //               child: const Text(
            //                 "DELETE",
            //                 style: TextStyle(color: Colors.red),
            //               ),
            //             )
            //           ],
            //         ));
            // },

            // onPressed: () async {
            //   await NotesDatabase.instance.delete(widget.noteId);

            //   Navigator.of(context).pop();
            // },
          ),
        ),
      );
}
