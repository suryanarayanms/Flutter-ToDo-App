import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/widget/about.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:todo_app/Main%20Pages/about.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

void _showdialog(BuildContext context) {
  showDialog(
    // barrierDismissible: false,
    builder: (BuildContext context) {
      return const CupertinoAlertDialog(
        title: Text(
          'Tamil Meme Templates\n',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Text(
          "Our products:\n\t\t\t\t- Tamil Meme Templates\n\t\t\t\t- Stack Notes\n\t\t\t\t- Rant\n\nCEO Surya will come back with lot more interesting products.",
          textAlign: TextAlign.left,
        ),
      );
    },
    context: context,
  );
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 10);
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: DelayedDisplay(
                delay: const Duration(milliseconds: 300),
                fadeIn: true,
                slidingBeginOffset: const Offset(0, 0),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                        child: GestureDetector(
                          onTap: () => _showdialog(context),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/512/6315/6315058.png",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextButton(
                      onPressed: () => selectedItem(context, 0),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 12, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'https://cdn-icons-png.flaticon.com/512/6314/6314049.png',
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: const Text(
                                  'Send Feedback!',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => selectedItem(context, 1),
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 12, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'https://cdn-icons-png.flaticon.com/512/3306/3306613.png',
                              height: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                child: const Text(
                                  'About',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //       left: 12, top: 10, bottom: 10, right: 12),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black.withOpacity(0.2),
                    //           spreadRadius: 1,
                    //           blurRadius: 10,
                    //           offset: const Offset(4, 4),
                    //         )
                    //       ],
                    //     ),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     TextButton(
                    //       style: ButtonStyle(
                    //         overlayColor: MaterialStateProperty.all(
                    //             Colors.grey.shade100),
                    //       ),
                    //       onPressed: () => {},
                    //       child: CachedNetworkImage(
                    //         imageUrl:
                    //             'https://cdn-icons-png.flaticon.com/512/6932/6932837.png',
                    //         height: 25,
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     TextButton(
                    //       style: ButtonStyle(
                    //         overlayColor: MaterialStateProperty.all(
                    //             Colors.grey.shade100),
                    //       ),
                    //       onPressed: () => {},
                    //       child: CachedNetworkImage(
                    //         imageUrl:
                    //             'https://cdn-icons-png.flaticon.com/512/107/107753.png',
                    //         height: 22,
                    //       ),
                    //     ),
                    //   ],
                    //  ),
                    // ),
                    //),
                  ],
                ),
              ),
            ),
            DelayedDisplay(
              delay: const Duration(milliseconds: 500),
              fadeIn: true,
              slidingBeginOffset: const Offset(0, 0),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 50,
                child: const Text(
                  'Made with ❤️ by Surya',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
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
      leading: Icon(icon, color: Colors.black),
      title: Text(text, style: const TextStyle(color: Colors.black)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: 'loveforbutterflyeffect@gmail.com',
          query: encodeQueryParameters(
              <String, String>{'subject': 'ToDo', 'body': 'Feedback: '}),
        );
        // ignore: deprecated_member_use
        launch(emailLaunchUri.toString());

        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AboutPage(),
        ));
        break;
    }
  }
}
