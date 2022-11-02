import 'package:flutter/material.dart';
import 'package:todo_app/db/notes_database.dart';
import 'package:todo_app/model/note.dart';
import 'package:todo_app/widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime timeBackPressed = DateTime.now();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          if (description != '' && title == '' ||
              title != '' && description != '') {
            addOrUpdateNote();
          } else {
            Navigator.of(context).pop();
          }
          throw {};
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 100,
            // actions: [buildButton()],
            leading: GestureDetector(
              onTap: () => {
                if (description != '' && title == '' ||
                    title != '' && description != '')
                  {addOrUpdateNote()}
                else
                  {Navigator.of(context).pop()}
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 20, top: 40.0),
                child: Icon(
                  Icons.keyboard_arrow_left_sharp,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: NoteFormWidget(
              isImportant: isImportant,
              number: number,
              title: title,
              description: description,
              onChangedImportant: (isImportant) =>
                  setState(() => this.isImportant = isImportant),
              onChangedNumber: (number) => setState(() => this.number = number),
              onChangedTitle: (title) => setState(() => this.title = title),
              onChangedDescription: (description) =>
                  setState(() => this.description = description),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 40.0, bottom: 60),
            child: GestureDetector(
              onTap: () async {
                addOrUpdateNote();
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    width: 50,
                  ),
                  const SizedBox(
                    height: 50,
                    width: 50,
                    child: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildButton() {
    // final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
