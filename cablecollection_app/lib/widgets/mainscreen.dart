import 'package:cablecollection_app/main.dart';
import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer_list.dart';
import 'package:cablecollection_app/providers/report.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/screens/collectionoverview.dart';
import 'package:cablecollection_app/screens/customerlistscreen.dart';
import 'package:cablecollection_app/screens/reportscreen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  static const routeName = '/MainScreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var isloading = false;
  var refresh = false;
  @override
  void initState() {
    super.initState();
  }

  void showNotification() {
    setState(() {});
    flutterLocalNotificationsPlugin.show(
        0,
        'hello',
        'how you doing',
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            importance: Importance.high,
            color: Colors.blue,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFF1E212D),
            title: Text('Eazy Bill'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    Provider.of<Auth>(context, listen: false)
                        .tryAutoLogin()
                        .then((value) {
                      if (value == true) {
                        setState(() {
                          refresh = true;
                        });
                        int date = DateTime.now().millisecondsSinceEpoch;
                        var token =
                            Provider.of<Auth>(context, listen: false).token;

                        Provider.of<CustomerList>(context, listen: false)
                            .refresh(date, token)
                            .then((value) {
                          if (value == 200) {
                            Provider.of<Auth>(context, listen: false)
                                .tryAutoLogin()
                                .then((value) {
                              if (value == true) {
                                token =
                                    Provider.of<Auth>(context, listen: false)
                                        .token;
                                Provider.of<AllCustomerList>(context,
                                        listen: false)
                                    .fetchAndSetCustomer(token)
                                    .then((value) {
                                  if (value == 200 || value == 201) {
                                    setState(() {
                                      refresh = false;
                                    });
                                  }
                                });
                              }
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Failed'),
                                content: Text('Unable to fetch the data'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('ok'),
                                  )
                                ],
                              ),
                            );
                          }
                        });
                      }
                    });
                  },
                  icon: refresh == false
                      ? Icon(Icons.miscellaneous_services_sharp)
                      : Icon(Icons.run_circle_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: isloading == true
                      ? Icon(Icons.refresh)
                      : Icon(Icons.report_sharp),
                  onPressed: () {
                    DateTime startDate = DateTime.now();
                    var myFormatData = DateFormat('yyyy-MM-dd');
                    DateTime firstDayCurrentMonth = DateTime.utc(
                        DateTime.now().year, DateTime.now().month, 1);
                    DateTime lastDayCurrentMonth = DateTime.utc(
                      DateTime.now().year,
                      DateTime.now().month + 1,
                    ).subtract(Duration(days: 1));
                    DateTime firstDayCurrentYear =
                        DateTime.utc(DateTime.now().year, 1, 1);

                    DateTime lastDayCurrentYear =
                        DateTime.utc(DateTime.now().year, 12, 31);

                    String todayDate = myFormatData.format(startDate);
                    String monthStartDate =
                        myFormatData.format(firstDayCurrentMonth);
                    String monthEndDate =
                        myFormatData.format(lastDayCurrentMonth);
                    String yearStartDate =
                        myFormatData.format(firstDayCurrentYear);
                    String yearEndDate =
                        myFormatData.format(lastDayCurrentYear);
                    Provider.of<Auth>(context, listen: false)
                        .tryAutoLogin()
                        .then((value) {
                      if (value == true) {
                        setState(() {
                          isloading = true;
                        });
                        var token =
                            Provider.of<Auth>(context, listen: false).token;
                        Provider.of<ReportList>(context, listen: false)
                            .getAllReport(todayDate, monthStartDate,
                                monthEndDate, yearStartDate, yearEndDate, token)
                            .then((value) {
                          setState(() {
                            isloading = false;
                          });
                          if (value['StatusCode'] == 200 ||
                              value['StatusCode'] == 201) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('Total Collection'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Todays Collection: '),
                                          Text(value['ResponseBody']['today']
                                              .toString())
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Monthly Collection: '),
                                          Text(value['ResponseBody']['month']
                                              .toString())
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Yearly Collection: '),
                                          Text(value['ResponseBody']['year']
                                              .toString())
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('ok'),
                                  )
                                ],
                              ),
                            );
                          } else {
                            failureDialog(context);
                          }
                          // if (value.isNotEmpty) {}
                        });
                      }
                    });
                  },
                ),
              ),
            ],
            floating: true,
            pinned: true,
            snap: true,
            bottom: TabBar(
              isScrollable: false,
              tabs: <Widget>[
                Tab(
                  text: 'Collection',
                ),
                Tab(
                  text: 'Customer List',
                ),
                Tab(
                  text: 'Report',
                )
              ],
            ),
          )
        ];
      },
      body: TabBarView(
        children: <Widget>[
          Center(
            child: CollectionOverView(),
          ),
          Center(
            child: CustomerListScreen(),
          ),
          Center(
            child: ReportScreen(),
          ),
        ],
      ),
    );
  }

  Future<dynamic> failureDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Failed'),
        content: Text('Unable to fetch the data'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }
}
