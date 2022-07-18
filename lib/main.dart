import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/Main%20Pages/ToDo/todopage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title

    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    // DevicePreview(
    // builder: (context) =>

    const MyApp(),

    // enabled: !kReleaseMode,
    // )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Flutter ToDo App',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dynamic notification = message.notification;
      dynamic android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: true,
                sound: const RawResourceAndroidNotificationSound(
                    'notification_sound'),
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
    _checkVersion();
  }

  starting() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getInt("thememode") != null) {
      thememode = pref.getInt("thememode")!;
    } else {
      pref.setInt("thememode", thememode);
    }
    setState(() {});
  }

  toggletheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getInt("thememode") == 1) {
      pref.setInt("thememode", 0);
      thememode = 0;
    } else {
      pref.setInt("thememode", 1);
      thememode = 1;
    }
    setState(() {});
  }

  void _checkVersion() async {
    final newVersion = NewVersion(androidId: 'com.ceosurya.todoapp');
    final status = await newVersion.getVersionStatus();
    if (status!.canUpdate) {
      newVersion.showUpdateDialog(
          context: context,
          versionStatus: status,
          dialogTitle: 'Update available!!!',
          dialogText: 'We have got an update for you. The app needs an update.',
          updateButtonText: 'Get updates',
          allowDismissal: false);
    }
  }

  // ThemeData _darkTheme = ThemeData(
  //     accentColor: Colors.red,
  //     brightness: Brightness.dark,
  //     primaryColor: Colors.amber);
  // ThemeData _lightTheme = ThemeData(
  //     accentColor: Colors.pink,
  //     brightness: Brightness.light,
  //     primaryColor: Colors.blue);

  int thememode = 0;
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'ToDo',
      theme: ThemeData(primaryColor: Colors.red),

      themeMode: thememode == 1 ? ThemeMode.dark : ThemeMode.light,
      // theme: MyThemes.lightTheme,

      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black45),
      home: const TodoPage(),
    );
  }
}
