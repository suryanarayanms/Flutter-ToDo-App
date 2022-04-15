import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:todo_app/Main%20Pages/ToDo/todopage.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String? appVersion;

  @override
  void initState() {
    main();
    super.initState();
  }

  Future<void> main() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 85),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(MaterialPageRoute(
                      builder: (context) => const TodoPage(),
                    ));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.keyboard_arrow_left_sharp,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'About',
                  style: GoogleFonts.spartan(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  )),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 19,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      width: 150,
                      child: Image(image: AssetImage('assets/splash.png')),
                    ),
                    const SizedBox(height: 17),
                    Text(
                      'ToDo',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spartan(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      )),
                    ),
                    Text(
                      'v$appVersion',
                      style: GoogleFonts.spartan(
                          textStyle: const TextStyle(
                        color: Colors.white,
                      )),
                    ),
                  ],
                ),
                // SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'ToDo Will Be An Open-Source Project And Can Be Found On',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spartan(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        )),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          launch('https://github.com/suryanarayanms');
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                  height: 25,
                                  image:
                                      AssetImage('assets/github_icon_2.png')),
                              const SizedBox(width: 7),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Text(
                                  'Github',
                                  style: GoogleFonts.spartan(
                                      textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Crush Over Love ❤️💫',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spartan(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    children: [
                      Text(
                        'For Queries',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spartan(
                            textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                      ),
                      // SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'loveforbutterflyeffect@gmail.com',
                            query: encodeQueryParameters(<String, String>{
                              'subject': 'ToDo',
                              'body': 'Query: '
                            }),
                          );
                          launch(emailLaunchUri.toString());
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.mail_outline_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 7),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Text(
                                  'Contact Us',
                                  style: GoogleFonts.spartan(
                                      textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Padding(padding: EdgeInsets.only(left: 17)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Made with ❤️ by Surya',
                          style: GoogleFonts.spartan(
                              textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(5, 30, 5, 20),
                //   child: Center(
                //     child: Text(
                //       'Made with ❤️ by Surya',
                //       style: GoogleFonts.spartan(
                //           textStyle: TextStyle(
                //         color: Colors.white,
                //         fontSize: 12,
                //       )),
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
