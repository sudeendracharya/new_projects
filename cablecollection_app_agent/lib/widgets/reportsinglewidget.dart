import 'dart:io';

import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';

class ReportSingleWidget extends StatefulWidget {
  @override
  _ReportSingleWidgetState createState() => _ReportSingleWidgetState();
}

class _ReportSingleWidgetState extends State<ReportSingleWidget> {
  var _selectdate;
  var _endDate;
  var number;
  final _form = GlobalKey<FormState>();
  var myFormatData = DateFormat('yyyy-MM-dd');

  Future<void> _saveForm(BuildContext context) async {
    String fromDate = myFormatData.format(_selectdate);
    String toDate = myFormatData.format(_endDate);
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      setState(() {
        isloading = true;
      });
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<ReportList>(context, listen: false)
              .getSingleCustomerReport(fromDate, toDate, number, token)
              .then((value) {
            if (value != 200) {
              // reRun();
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

  var isloading = false;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  // share(BuildContext context)
  // {
  //   Share.shareFiles(paths)
  // }

  void _fromDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2016),
      lastDate: DateTime(2025),
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
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _endDate = pickedDate;
      });
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
        ? Center(child: Text('Loading Data'))
        : Form(
            key: _form,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Card(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Mobile Number'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please Enter The Mobile Number';
                          }

                          //this returning null ensures that there is no error
                          return null;
                        },
                        onSaved: (value) {
                          number = value;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
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
                                : ' ${DateFormat.yMEd().format(_selectdate)}',
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
                                : ' ${DateFormat.yMEd().format(_endDate)}',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: share,
                      child: Text('Share'),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveForm(context);
                      },
                      child: Text('Submit'),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
