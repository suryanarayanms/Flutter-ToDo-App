import 'package:todo_app/page/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/db/notes_database.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/page/edit_note_page.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 100,
          leading: GestureDetector(
            onTap: () => {Navigator.of(context).pop()},
            child: const Padding(
              padding: EdgeInsets.only(left: 20, top: 40.0),
              child: Icon(
                Icons.keyboard_arrow_left_sharp,
                color: Colors.black,
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
        // floatingActionButton: Padding(
        //   padding: EdgeInsets.only(right: 40.0, bottom: 60),
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.red[400],
        //     child: Icon(Icons.delete),
        //     shape:
        //         BeveledRectangleBorder(borderRadius: BorderRadius.circular(2)),
        //     onPressed: () async {
        //       await NotesDatabase.instance.delete(widget.noteId);

        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 30, right: 30, bottom: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: [
                          // Text(
                          //   note.title,
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 22,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          Text(
                            note.description,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );

  Widget editButton() => Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 10, bottom: 10),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.blue[400],
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
        ),
      );

  Widget deleteButton() => Padding(
        padding: const EdgeInsets.only(top: 8.0, right: 20, bottom: 10),
        child: Visibility(
          visible: true,
          child: GestureDetector(
            // onTap: () async {
            // await NotesDatabase.instance.delete(widget.noteId);

            // Navigator.of(context).pop();
            // },
            onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Delete Note"),
                      content:
                          const Text("This note will be deleted permanently"),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
}
