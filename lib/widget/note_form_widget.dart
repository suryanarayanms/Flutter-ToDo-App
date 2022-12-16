import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/toggletheme.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.watch<ChangeTheme>().currenttheme
            ? Colors.white
            : const Color.fromRGBO(30, 30, 30, 1),
        body: Padding(
          padding: const EdgeInsets.only(top: 16, left: 30, right: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // buildTitle(), - You cannot use context.watch inside a widget
              TextFormField(
                cursorColor: context.watch<ChangeTheme>().currenttheme
                    ? Colors.blue[400]
                    : Colors.white,
                maxLines: 1,
                initialValue: title,
                style: TextStyle(
                  color: context.watch<ChangeTheme>().currenttheme
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                  hintStyle: TextStyle(
                      color: context.watch<ChangeTheme>().currenttheme
                          ? Colors.black
                          : Colors.white70),
                ),
                // validator: (title) =>
                //     title != null && title.isEmpty ? 'The title cannot be empty' : null,
                onChanged: onChangedTitle,
              ),
              // buildDescription(), - You cannot use context.watch inside a widget
              Expanded(
                child: TextFormField(
                  cursorColor: context.watch<ChangeTheme>().currenttheme
                      ? Colors.blue[400]
                      : Colors.white,
                  // minLines: -,
                  maxLines: 100000000,
                  maxLength: 100000000,
                  initialValue: description,
                  style: TextStyle(
                      color: context.watch<ChangeTheme>().currenttheme
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18),
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    hintText: 'Type something...',
                    hintStyle: TextStyle(
                        color: context.watch<ChangeTheme>().currenttheme
                            ? Colors.black
                            : Colors.white70),
                  ),
                  validator: (title) => title != null && title.isEmpty
                      ? 'The description cannot be empty'
                      : null,
                  onChanged: onChangedDescription,
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.black),
        ),
        // validator: (title) =>
        //     title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => Expanded(
        child: TextFormField(
          // minLines: -,
          maxLines: 100000000,
          maxLength: 100000000,
          initialValue: description,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: 'Type something...',
            hintStyle: TextStyle(color: Colors.black),
          ),
          validator: (title) => title != null && title.isEmpty
              ? 'The description cannot be empty'
              : null,
          onChanged: onChangedDescription,
        ),
      );
}
