import 'package:flutter/material.dart';
import 'package:todo_app/model/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;
  // String a;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 20),
      child: Container(
        // height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        // width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        padding:
            const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   time,
            //   style: TextStyle(color: Colors.grey.shade700),
            // ),
            // SizedBox(height: 4),

            Text(
              note.title,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note.description,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                // fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "...",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
