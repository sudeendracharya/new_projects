import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/widgets/areabuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CollectionOverView extends StatefulWidget {
  CollectionOverView({Key key}) : super(key: key);

  @override
  _CollectionOverViewState createState() => _CollectionOverViewState();
}

class _CollectionOverViewState extends State<CollectionOverView>
    with AutomaticKeepAliveClientMixin<CollectionOverView> {
  List areaList = [];
  List areaData = [];
  int totalActive = 0;
  int totalInactive = 0;
  int totalStore = 0;
  List<Map<String, dynamic>> activeInactive = [];
  var today;
  var month;
  var year;
  @override
  void initState() {
    DateTime startDate = DateTime.now();
    var myFormatData = DateFormat('yyyy-MM-dd');
    DateTime firstDayCurrentMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
    DateTime lastDayCurrentMonth = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(Duration(days: 1));
    DateTime firstDayCurrentYear = DateTime.utc(DateTime.now().year, 1, 1);

    DateTime lastDayCurrentYear = DateTime.utc(DateTime.now().year, 12, 31);

    String todayDate = myFormatData.format(startDate);
    String monthStartDate = myFormatData.format(firstDayCurrentMonth);
    String monthEndDate = myFormatData.format(lastDayCurrentMonth);
    String yearStartDate = myFormatData.format(firstDayCurrentYear);
    String yearEndDate = myFormatData.format(lastDayCurrentYear);
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<ReportList>(context, listen: false)
            .getAllReport(todayDate, monthStartDate, monthEndDate,
                yearStartDate, yearEndDate, token)
            .then((value) {
          if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
            today = value['ResponseBody']['today'] == null
                ? '0'
                : value['ResponseBody']['today'];
            month = value['ResponseBody']['month'] == null
                ? '0'
                : value['ResponseBody']['month'];
            year = value['ResponseBody']['year'] == null
                ? '0'
                : value['ResponseBody']['year'];
            reRun();
          } else {
            reRun();
          }
        });
      }
    });
    super.initState();
  }

  Future<void> refreshProducts(BuildContext context) async {
    DateTime startDate = DateTime.now();
    var myFormatData = DateFormat('yyyy-MM-dd');
    DateTime firstDayCurrentMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
    DateTime lastDayCurrentMonth = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(Duration(days: 1));
    DateTime firstDayCurrentYear = DateTime.utc(DateTime.now().year, 1, 1);

    DateTime lastDayCurrentYear = DateTime.utc(DateTime.now().year, 12, 31);

    String todayDate = myFormatData.format(startDate);
    String monthStartDate = myFormatData.format(firstDayCurrentMonth);
    String monthEndDate = myFormatData.format(lastDayCurrentMonth);
    String yearStartDate = myFormatData.format(firstDayCurrentYear);
    String yearEndDate = myFormatData.format(lastDayCurrentYear);
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<ReportList>(context, listen: false)
            .getAllReport(todayDate, monthStartDate, monthEndDate,
                yearStartDate, yearEndDate, token)
            .then((value) {
          if (value['StatusCode'] == 200 || value['StatusCode'] == 201) {
            today = value['ResponseBody']['today'];
            month = value['ResponseBody']['month'];
            year = value['ResponseBody']['year'];
            reRun();
          } else {
            reRun();
          }
        });
      }
    });
  }

  var isloading = true;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        :
        //  isloading == false
        //     ? Center(child: Text('loading Data'))
        //:
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Container(
              width: MediaQuery.of(context).size.width - 30,
              child: Card(
                child: RefreshIndicator(
                  onRefresh: () => refreshProducts(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Collection Total',
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Todays Collection: ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            ),
                            Text(
                              today.toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Collection: ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            ),
                            Text(
                              month.toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Yearly Collection: ',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            ),
                            Text(
                              year.toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 15),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
