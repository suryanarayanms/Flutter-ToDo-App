import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Main%20Pages/about.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 10);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  const DrawerHeader(
                    child: Icon(
                      Icons.all_inclusive,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const SizedBox(height: 1),
                  TextButton(
                    onPressed: () => selectedItem(context, 1),
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, top: 10),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                'https://i.pinimg.com/originals/f4/c2/3a/f4c23a6017e875a4e9b121cbb3857351.png',
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Text(
                                'About',
                                style: GoogleFonts.spartan(
                                    textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 50,
              child: Text(
                'Made with ❤️ by Surya',
                style: GoogleFonts.spartan(
                    textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                )),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final hoverColor = Colors.grey[100];

    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      //  style: GoogleFonts.raleway(
      //           textStyle:
      //               TextStyle(color: Colors.white, fontWeight: FontWeight.w400))),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AboutPage(),
        ));
        break;
    }
  }
}
