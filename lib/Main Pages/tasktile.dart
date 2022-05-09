import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({Key? key, this.title, this.desc}) : super(key: key);
  final dynamic title;
  final dynamic desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 0),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(No title added)",
            style: GoogleFonts.spartan(
                textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              desc ??
                  "The Task is corrupted.\nProvide a description next time.",
              style: GoogleFonts.spartan(
                  textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              )),
            ),
          ),
        ],
      ),
    );
  }
}
