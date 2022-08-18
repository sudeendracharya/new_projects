import 'dart:io';

import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/widgets/select_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class YearlyReportWidget extends StatefulWidget {
  YearlyReportWidget({Key key}) : super(key: key);

  @override
  _YearlyReportWidgetState createState() => _YearlyReportWidgetState();
}

class _YearlyReportWidgetState extends State<YearlyReportWidget> {
  var isloading = false;

  DateTime firstDayCurrentYear = DateTime.utc(DateTime.now().year, 1, 1);

  DateTime lastDayCurrentYear = DateTime.utc(DateTime.now().year, 12, 31);
  var myFormat = DateFormat('yyyy-MM-dd');
  Future<void> _saveForm() async {
    try {
      String startDate = myFormat.format(firstDayCurrentYear);
      String endDate = myFormat.format(lastDayCurrentYear);
      var selectedArea = SelectArea.areaList;
      setState(() {
        isloading = true;
      });
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<ReportList>(context, listen: false)
              .getReport(startDate, endDate, token, selectedArea)
              .then((value) {
            if (value != 200) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('An error Occured '),
                  content: Text('Something Went Wrong in fetching bill '),
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
              reRun();
            }
          });
        }
      });
      // await Provider.of<CustomerList>(context, listen: false)
      //     .getReport(firstDayCurrentYear, lastDayCurrentYear);
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error Occured '),
          content: Text('Something Went Wrong in fetching bill '),
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

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  void share() async {
    String startDate = myFormat.format(firstDayCurrentYear);
    String endDate = myFormat.format(lastDayCurrentYear);
    List<Directory> dir = await getExternalStorageDirectories();
    File testFile = new File("${dir.first.path}/${startDate}to$endDate.xlsx");
    if (!await testFile.exists()) {
      // await testFile.create(recursive: true);
      // testFile.writeAsStringSync("test for share documents file");

    }
    ShareExtend.share(testFile.path, "file");
  }

  @override
  Widget build(BuildContext context) {
    String startDate = myFormat.format(firstDayCurrentYear);
    String endDate = myFormat.format(lastDayCurrentYear);

    return isloading == true
        ? Center(child: Text('Loading Report'))
        : Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    // alignment: Alignment.topLeft,
                    child: Text(
                      'Bill From:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    // alignment: Alignment.center,
                    child: Text(
                      startDate,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    //alignment: Alignment.centerLeft,
                    child: Text(
                      'Bill To:',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    // alignment: Alignment.center,
                    child: Text(
                      endDate,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SelectArea(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: share,
                    child: Text('Share'),
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  ElevatedButton(
                    onPressed: _saveForm,
                    child: Text('Submit'),
                  ),
                ],
              )
            ],
          );
  }
}
