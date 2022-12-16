import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/note.dart';

import '../Provider/toggletheme.dart';

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
          color: context.watch<ChangeTheme>().currenttheme
              ? Colors.white
              : Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: context.watch<ChangeTheme>().currenttheme
                  ? Colors.black.withOpacity(0.1)
                  : Colors.transparent,
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
              style: TextStyle(
                color: context.watch<ChangeTheme>().currenttheme
                    ? Colors.black
                    : Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note.description,
              maxLines: 2,
              style: TextStyle(
                color: context.watch<ChangeTheme>().currenttheme
                    ? Colors.black
                    : Colors.white,
                fontSize: 15,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
