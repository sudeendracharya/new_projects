import 'dart:developer';

import 'package:cablecollection_app/providers/areaList.dart';
import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/blist.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer_list.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/screens/addcustomerscreen.dart';
import 'package:cablecollection_app/screens/area_wise_customer_list_screen.dart';
import 'package:cablecollection_app/screens/authscreen.dart';
import 'package:cablecollection_app/screens/billingscreen.dart';
import 'package:cablecollection_app/screens/complaints_screen.dart';
import 'package:cablecollection_app/screens/customerdetailsscreen.dart';
import 'package:cablecollection_app/screens/display_notification_data.dart';
import 'package:cablecollection_app/screens/edit_report_screen.dart';
import 'package:cablecollection_app/screens/individual_customer_complaint_screen.dart';
import 'package:cablecollection_app/screens/node_wise_customer_list.dart';
import 'package:cablecollection_app/screens/reportscreen.dart';
import 'package:cablecollection_app/screens/splashScreen.dart';
import 'package:cablecollection_app/screens/store_screen.dart';
import 'package:cablecollection_app/screens/todo_screen.dart';
import 'package:cablecollection_app/widgets/tabbarcontroller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/signupscreen.dart';
import 'widgets/mainscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

var baseUrl = 'https://demoeazybill.herokuapp.com/';
// var baseUrl = 'https://samasthadeeparednet.herokuapp.com/';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,

  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  print('A Message Showed Up:${message.data['body']}');
  flutterLocalNotificationsPlugin.show(
      1,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: Importance.max,
          priority: Priority.max,
          color: Colors.blue,
        ),
      ),
      payload: message.data['cuId']);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  runApp(MyHome());
}

class MyHome extends StatefulWidget {
  const MyHome({Key key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
//   @override
//   Widget build(BuildContext context) {
//     return MyApp();
//   }
// }

// class MyApp extends StatefulWidget {

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
  static const routeName = '/';
  final Color darkBlue = Color(0xFFE4FBFF);
  final navigatorKey = GlobalKey<NavigatorState>();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  @override
  void initState() {
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    FirebaseMessaging.instance.getToken().then((value) {
      log(value);
    });
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    checkForInitialMessage();

    super.initState();
  }

  Future<dynamic> onSelectNotification(payload) async {
// navigate to booking screen if the payload equal BOOKING
    this
        .navigatorKey
        .currentState
        .pushNamed(ReportScreen.routeName, arguments: payload);
// if(payload == "BOOKING"){
//  this.navigatorKey.currentState.pushNamed(
//  NotificationDataDisplay.routeName
//    );
//  }
  }

  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // PushNotification notification = PushNotification(
      //   title: initialMessage.notification?.title,
      //   body: initialMessage.notification?.body,
      // );
      // setState(() {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(initialMessage.notification.title),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(initialMessage.notification.body)],
                ),
              ),
            );
          });
      // });
    }
  }

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AllCustomerList(),
        ),
        ChangeNotifierProxyProvider<Auth, CustomerList>(
          create: (ctx) => CustomerList(),
          update: (ctx, auth, previousList) => CustomerList(auth.token),
        ),
        ChangeNotifierProxyProvider<Auth, BillList>(
          create: (ctx) => BillList(),
          update: (ctx, auth, previousList) => BillList(auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReportList(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AreaList(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          navigatorKey: navigatorKey,
          theme: ThemeData.light(),
          title: 'Cable Collection',
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? tabBarController(darkBlue: darkBlue)
              : FutureBuilder(
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  future: auth.tryAutoLogin(),
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            MainScreen.routeName: (ctx) => MainScreen(),
            tabBarController.routeName: (ctx) => tabBarController(
                  darkBlue: Color(0xFFE4FBFF),
                ),
            // MyApp.routeName: (ctx) => MyApp(),
            AddCustomerScreen.routeName: (ctx) => AddCustomerScreen(),
            CustomerDetailsScreen.routeName: (ctx) => CustomerDetailsScreen(),
            BillingScreen.routeName: (ctx) => BillingScreen(),
            StoreScreen.routeName: (ctx) => StoreScreen(),
            Complaints.routeName: (ctx) => Complaints(),
            TodoScreen.routeName: (ctx) => TodoScreen(),
            IndividualCustomerComplaint.routeName: (ctx) =>
                IndividualCustomerComplaint(),
            AreaWiseCustomerList.routeName: (ctx) => AreaWiseCustomerList(),
            NodeWiseCustomerList.routeName: (ctx) => NodeWiseCustomerList(),
            SignUpScreen.routeName: (ctx) => SignUpScreen(),
            NotificationDataDisplay.routeName: (ctx) =>
                NotificationDataDisplay(),
            ReportScreen.routeName: (ctx) => ReportScreen(),
            EditReportScreen.routeName: (ctx) => EditReportScreen(),
          },
        ),
      ),
    );
  }
}
