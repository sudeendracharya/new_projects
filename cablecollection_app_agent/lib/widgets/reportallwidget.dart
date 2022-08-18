import 'dart:io';

import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/widgets/select_area_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class ReportAllWidget extends StatefulWidget {
  ReportAllWidget({Key key}) : super(key: key);

  @override
  _ReportAllWidgetState createState() => _ReportAllWidgetState();
}

class _ReportAllWidgetState extends State<ReportAllWidget>
    with AutomaticKeepAliveClientMixin {
  var _selectdate;
  var isloading = false;
  var _endDate;
  var myFormatData = DateFormat('yyyy-MM-dd');
  static var areaSelected = false;
  static var selectedArea = '';
  void _fromDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectdate = pickedDate;
      });
    });
  }

  void _toDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _endDate = pickedDate;
      });
    });
  }

  Future<void> _saveForm() async {
    try {
      if (_selectdate == null || _endDate == null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error Occured '),
            content: Text('Please Select the date '),
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
      String fromDate = myFormatData.format(_selectdate);
      String toDate = myFormatData.format(_endDate);
      var selectedArea = SelectArea.areaList;
      setState(() {
        isloading = true;
      });
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<ReportList>(context, listen: false)
              .getReport(fromDate, toDate, token, selectedArea)
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
    String fromDate = myFormatData.format(_selectdate);
    String toDate = myFormatData.format(_endDate);
    List<Directory> dir = await getExternalStorageDirectories();
    File testFile = new File("${dir.first.path}/${fromDate}to$toDate.xlsx");
    if (!await testFile.exists()) {
      // await testFile.create(recursive: true);
      // testFile.writeAsStringSync("test for share documents file");

    }
    ShareExtend.share(testFile.path, "file");
  }

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? Center(
            child: Text('Loading Data'),
          )
        : Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: _fromDatePicker,
                child: Row(
                  children: [
                    Container(
                      // alignment: Alignment.topLeft,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Bill From:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _selectdate == null
                              ? ''
                              : ' ${DateFormat.yMMMMEEEEd().format(_selectdate)}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: _toDatePicker,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      //alignment: Alignment.centerLeft,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Bill To:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          _endDate == null
                              ? ''
                              : ' ${DateFormat.yMMMMEEEEd().format(_endDate)}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              SelectArea(),
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

  @override
  bool get wantKeepAlive => true;
}
