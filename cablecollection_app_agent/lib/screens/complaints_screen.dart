import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Complaints extends StatefulWidget {
  Complaints({Key key}) : super(key: key);

  static const routeName = '/Complaints';

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _selectdate;
  var isloading = true;

  var myFormatData = DateFormat('dd-MM-yyyy');
  List complaintList = [];

  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchAllComplaints(token)
            .then((value) {
          if (value.isNotEmpty) {
            complaintList = value;
            reRun();
          } else {
            reRun();
          }
        });
      }
    });
    super.initState();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  void DatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
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

  void getData() {
    setState(() {
      isloading = true;
    });
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchAllComplaints(token)
            .then((value) {
          complaintList = value;
          reRun();
        });
      }
    });
  }

  int _count = 0;
  void _update(int count) {
    _count = count;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Success'),
        content: Text('Successfully deleted the Data'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              getData();
            },
            child: const Text('ok'),
          )
        ],
      ),
    );
  }

  void get(int count) {
    _count = count;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaints'),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: complaintList.length,
              itemBuilder: (BuildContext context, int index) {
                return ComplaintScreenData(
                  complaintList: complaintList,
                  myFormatData: myFormatData,
                  index: index,
                  key: UniqueKey(),
                  compId: complaintList[index]['compId'],
                  update: _update,
                  get: get,
                );
              },
            ),
    );
  }
}

class ComplaintScreenData extends StatefulWidget {
  ComplaintScreenData({
    Key key,
    @required this.complaintList,
    @required this.myFormatData,
    @required this.index,
    @required this.compId,
    @required this.update,
    @required this.get,
  }) : super(key: key);

  final List complaintList;
  final DateFormat myFormatData;
  final int index;
  var compId;
  final ValueChanged<int> update;
  final ValueChanged<int> get;
  @override
  State<ComplaintScreenData> createState() => _ComplaintScreenDataState();
}

class _ComplaintScreenDataState extends State<ComplaintScreenData> {
  void delete() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .deleteComplaint(widget.compId, token)
            .then((value) {
          if (value == 201 || value == 200) {
            widget.update(100);
          }
        });
      }
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                var selectdate =
                    DateTime.parse(widget.complaintList[widget.index]['date']);
                Map<String, String> todo = {
                  'title': '',
                  'description': '',
                  'date': selectdate.millisecondsSinceEpoch.toString(),
                  'compId': widget.compId.toString(),
                };

                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text("Edit"),
                      content: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              initialValue: widget.complaintList[widget.index]
                                  ['title'],
                              decoration: InputDecoration(labelText: 'Title'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide a Title';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                todo['title'] = value;
                              },
                            ),
                            TextFormField(
                              maxLines: 3,
                              initialValue: widget.complaintList[widget.index]
                                  ['description'],
                              decoration:
                                  InputDecoration(labelText: 'description'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please provide a description';
                                }
                                //this returning null ensures that there is no error
                                return null;
                              },
                              onSaved: (value) {
                                todo['description'] = value;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    selectdate == null
                                        ? Text('Date Is Not Selected')
                                        : Text(
                                            ' ${DateFormat.yMEd().format(selectdate)}'),
                                    ElevatedButton(
                                        onPressed: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2018),
                                            lastDate: DateTime(2030),
                                          ).then((pickedDate) {
                                            if (pickedDate == null) {
                                              return;
                                            }

                                            setState(() {
                                              selectdate = pickedDate;
                                              print(pickedDate
                                                  .millisecondsSinceEpoch);
                                              todo['date'] = pickedDate
                                                  .millisecondsSinceEpoch
                                                  .toString();
                                            });
                                          });
                                        },
                                        child: Text('Pick Date'))
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            final isvalid = _formKey.currentState.validate();
                            if (isvalid == false) {
                              return;
                            }
                            _formKey.currentState.save();
                            Provider.of<Auth>(context, listen: false)
                                .tryAutoLogin()
                                .then((value) {
                              if (value == true) {
                                var token =
                                    Provider.of<Auth>(context, listen: false)
                                        .token;
                                Provider.of<CustomerList>(context,
                                        listen: false)
                                    .editComplaint(todo, token)
                                    .then((value) {
                                  if (value == 201 || value == 200) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Success'),
                                        content: Text(
                                            'Successfully updated the Data'),
                                        actions: [
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              Navigator.pop(context);
                                              widget.get(100);
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
                                        content: Text(
                                            'Something Went wrong Please try again'),
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
                          child: Text("Update"),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
          icon: Icon(Icons.edit)),
      trailing: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Delete'),
                content: Text('Are you Sure Want to Delete'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('cancel'),
                  ),
                  FlatButton(
                    onPressed: () {
                      delete();
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('ok'),
                  )
                ],
              ),
            );
          },
          icon: Icon(Icons.delete)),
      title: Text(widget.complaintList[widget.index]['title']),
      subtitle: Text(
          '${widget.complaintList[widget.index]['description']}  ${widget.myFormatData.format(DateTime.parse(widget.complaintList[widget.index]['date']))}'),
    );
  }
}
