import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditReportScreen extends StatefulWidget {
  EditReportScreen({Key key}) : super(key: key);

  static const routeName = '/EditReportScreen';

  @override
  _EditReportScreenState createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isloading = true;
  var myFormatData = DateFormat('dd-MM-yyyy');
  TextEditingController _fromDateCtrl = TextEditingController();
  TextEditingController _toDateCtrl = TextEditingController();
  TextEditingController _numOfDays = TextEditingController();

  var numberOfDays;
  DateTime fromDate;
  DateTime toDate;

  var _initValues = {
    'PaidAmount': '',
    'Due': '',
    'Advance': null,
    'Days': '',
    'BillNo': '',
    'BillFrom': '',
    'BillTo': '',
  };

  Map<String, dynamic> _savedValues = {
    'PaidAmount': '',
    'Due': '',
    'Advance': null,
    'Days': '',
    'BillNo': '',
    'BillFrom': '',
    'BillTo': '',
    'buId': '',
  };
  var myFormat = DateFormat('d-MM-yyyy');

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then(
      (value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          if (ReportList.buId != null) {
            Provider.of<ReportList>(context, listen: false)
                .getSingleBill(ReportList.buId, token)
                .then((value) {
              if (value['statusCode'] == 201 || value['statusCode'] == 200) {
                _initValues = {
                  'PaidAmount': value['extratedData']['PaidAmount'].toString(),
                  'Due': value['extratedData']['Due'].toString(),
                  'Advance': value['extratedData']['Advance'].toString(),
                  'Days': value['extratedData']['Days'].toString(),
                  'BillNo': value['extratedData']['BillNo'].toString(),
                  'BillFrom': value['extratedData']['BillFrom'],
                  'BillTo': value['extratedData']['BillTo'],
                };
                numberOfDays = int.parse(
                  value['extratedData']['Days'].toString(),
                );
                _numOfDays.text = numberOfDays.toString();
                _savedValues['buId'] = value['extratedData']['buId'];

                _fromDateCtrl.text = myFormat
                    .format(DateTime.parse(value['extratedData']['BillFrom']));

                _toDateCtrl.text = myFormat
                    .format(DateTime.parse(value['extratedData']['BillTo']));

                fromDate = DateTime.parse(value['extratedData']['BillFrom']);
                toDate = DateTime.parse(value['extratedData']['BillTo']);
                _savedValues['BillFrom'] =
                    DateTime.parse(value['extratedData']['BillFrom'])
                        .millisecondsSinceEpoch;
                _savedValues['BillTo'] =
                    DateTime.parse(value['extratedData']['BillTo'])
                        .millisecondsSinceEpoch;

                reRun();
              } else {
                reRun();
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Failed'),
                    content: Text('Bill updating Failed Please Try Again'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
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
        }
      },
    );

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   if (ModalRoute.of(context).settings.arguments != null) {
  //     var data =
  //         ModalRoute.of(context).settings.arguments as Map<String, String>;
  //   }
  // }

  void reRun() {
    setState(() {
      _isloading = false;
    });
  }

  void _fromdate() {
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
        fromDate = pickedDate;
        _savedValues['BillFrom'] = pickedDate.millisecondsSinceEpoch;
        print(_savedValues['BillFrom']);
        _fromDateCtrl.text = myFormatData.format(pickedDate);
        numberOfDays = toDate.difference(fromDate).inDays;
        _numOfDays.text = numberOfDays.toString();
      });
    });
  }

  void _todate() {
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
        toDate = pickedDate;
        _savedValues['BillTo'] = pickedDate.millisecondsSinceEpoch;
        print(_savedValues['BillTo']);
        _toDateCtrl.text = myFormatData.format(pickedDate);
        numberOfDays = toDate.difference(fromDate).inDays;
        _numOfDays.text = numberOfDays.toString();

        print(numberOfDays);
      });
    });
  }

  Future<void> _saveForm() async {
    print('data');
    final isvalid = _formKey.currentState.validate();
    if (isvalid == false) {
      return;
    }
    _formKey.currentState.save();

    // setState(() {
    //   _isloading = true;
    // });
    print(_savedValues);

    try {
      await Provider.of<Auth>(context, listen: false).tryAutoLogin().then(
        (value) {
          if (value == true) {
            var token = Provider.of<Auth>(context, listen: false).token;
            Provider.of<ReportList>(context, listen: false)
                .updateBill(_savedValues, token)
                .then((value) {
              if (value == 201 || value == 200) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Success'),
                    content: Text('Bill Successfully updated'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('ok'),
                      )
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Failed'),
                    content: Text('Bill updating Failed Please Try Again'),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
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
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed'),
          content: Text(error),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(ctx).pop();
              },
              child: const Text('ok'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF1E212D),
                title: Text('Update Customer Bill'),
              ),
              body: _isloading == true
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: SingleChildScrollView(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Update Bill'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    initialValue: _initValues['PaidAmount'],
                                    decoration: InputDecoration(
                                        labelText: 'Paid Amount'),
                                    onSaved: (value) {
                                      _savedValues['PaidAmount'] = value;
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: _initValues['Due'],
                                    decoration: InputDecoration(
                                      labelText: 'Due',
                                    ),
                                    onSaved: (value) {
                                      _savedValues['Due'] = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please provide a due';
                                      }
                                      //this returning null ensures that there is no error
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: _initValues['Advance'],
                                    decoration:
                                        InputDecoration(labelText: 'Advance'),
                                    onSaved: (value) {
                                      _savedValues['Advance'] = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please provide a Number';
                                      }
                                      //this returning null ensures that there is no error
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    // initialValue: numberOfDays.toString(),
                                    controller: _numOfDays,
                                    decoration:
                                        InputDecoration(labelText: 'days'),
                                    onChanged: (value) {
                                      if (value == 0 ||
                                          value == null ||
                                          value.isEmpty) {
                                        return;
                                      } else {
                                        setState(
                                          () {
                                            numberOfDays = int.tryParse(value);
                                            toDate = fromDate.add(Duration(
                                                days: numberOfDays,
                                                hours: 0,
                                                minutes: 0,
                                                seconds: 0));

                                            _toDateCtrl.text =
                                                myFormat.format(toDate);
                                            _savedValues['BillTo'] =
                                                toDate.millisecondsSinceEpoch;
                                            print(_savedValues['BillTo']);
                                          },
                                        );
                                      }
                                    },
                                    onSaved: (value) {
                                      _savedValues['Days'] = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please provide a SmartCard Number';
                                      }
                                      //this returning null ensures that there is no error
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    initialValue: _initValues['BillNo'],
                                    decoration:
                                        InputDecoration(labelText: 'BillNo*'),
                                    onSaved: (value) {
                                      _savedValues['BillNo'] = value;
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'please provide a Area';
                                      }
                                      //this returning null ensures that there is no error
                                      return null;
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: TextFormField(
                                          // initialValue: _initValues['BillFrom'],
                                          decoration: InputDecoration(
                                              labelText: 'BillFrom*'),
                                          enabled: false,
                                          controller: _fromDateCtrl,
                                          // onSaved: (value) {
                                          //   _savedValues['BillFrom'] = value;
                                          // },
                                          // validator: (value) {
                                          //   if (value.isEmpty) {
                                          //     return 'please provide Node';
                                          //   }
                                          //   //this returning null ensures that there is no error
                                          //   return null;
                                          // },
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black)),
                                          onPressed: _fromdate,
                                          child: Text('Pick Date'))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: TextFormField(
                                          // initialValue: _initValues['BillTo'],
                                          decoration: InputDecoration(
                                              labelText: 'BillTo*'),
                                          enabled: false,
                                          controller: _toDateCtrl,
                                          // onSaved: (value) {
                                          //   _savedValues['BillTo'] = value;
                                          // },
                                          // validator: (value) {
                                          //   if (value.isEmpty) {
                                          //     return 'please provide Node';
                                          //   }
                                          //   //this returning null ensures that there is no error
                                          //   return null;
                                          // },
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.black)),
                                          onPressed: _todate,
                                          child: Text('Pick Date'))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  RaisedButton(
                                      color: Colors.black,
                                      onPressed: _saveForm,
                                      child: Text(
                                        'Update Bill',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          );
  }
}
