import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatefulWidget {
  AddCustomerScreen({Key key}) : super(key: key);

  static const routeName = '/AddCustomerScreen';

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isloading = false;
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  var _isInit = true;
  var cusId;
  var _newCustomer = Customer(
    id: '',
    name: '',
    mobile: null,
    smartCardNumber: '',
    area: '',
    node: '',
    address: '',
    stbId: '',
    tv: '',
    packages: '',
    packageAmount: '',
    email: '',
    aadharnumber: '',
    stbMaterial: '',
    due: '',
    advance: '',
    status: '',
    subscriptionEndDate: '',
  );
  var _initValues = {
    'id': '',
    'name': '',
    'mobile': null,
    'smartCardNumber': '',
    'area': '',
    'node': '',
    'address': '',
    'stbId': '',
    'tv': '',
    'packages': '',
    'packageAmount': '',
    'email': '',
    'aadharnumber': '',
    'stbMaterial': '',
    'due': '',
    'advance': '',
    'status': '',
    'subscriptionEndDate': '',
  };

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      cusId = ModalRoute.of(context).settings.arguments;
      if (cusId != null) {
        setState(() {
          _isloading = true;
        });
        Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
          if (value == true) {
            var token = Provider.of<Auth>(context, listen: false).token;
            Provider.of<CustomerList>(context, listen: false)
                .fetchCustomerDetails(cusId, token)
                .then((value) {
              if (value != null) {
                // customerData = value;
                // print(customerData.toString());
                if (value['Status'] == 'ACTIVE') {
                  value1 = true;
                } else if (value['Status'] == 'INACTIVE') {
                  value2 = true;
                } else {
                  value3 = true;
                }

                setState(() {
                  _initValues = {
                    'id': value['id'],
                    'name': value['Name'],
                    'smartCardNumber': value['SmartCardNumber'],
                    'mobile': value['Mobile'].toString(),
                    'packageAmount': value['PackageAmount'],
                    'stbId': value['StbId'],
                    'tv': value['TV'],
                    'packages': value['Packages'],
                    'address': value['Address'],
                    'area': value['Area'],
                    'node': value['Node'],
                    'subscriptionEndDate': value['SubscriptionEndDate'],
                    'status': value['Status'],
                    'stbMaterial': value['stb mateirial'],
                  };
                  _newCustomer = Customer(
                    id: _newCustomer.id,
                    name: _newCustomer.name,
                    mobile: _newCustomer.mobile,
                    smartCardNumber: _newCustomer.smartCardNumber,
                    area: _newCustomer.area,
                    node: _newCustomer.node,
                    address: _newCustomer.address,
                    stbId: _newCustomer.stbId,
                    tv: _newCustomer.tv,
                    packages: _newCustomer.packages,
                    packageAmount: _newCustomer.packageAmount,
                    email: _newCustomer.email,
                    aadharnumber: _newCustomer.aadharnumber,
                    stbMaterial: _newCustomer.stbMaterial,
                    due: _newCustomer.due,
                    advance: _newCustomer.advance,
                    status: value['Status'],
                    subscriptionEndDate: _newCustomer.subscriptionEndDate,
                  );
                });
                reRun();
              }
            });
          }
        });
      }
    }
    _isInit = false;
  }

  void reRun() {
    setState(() {
      _isloading = false;
    });
  }

  // void statusCheck() {
  //   if (_initValues['status'] == 'true') {
  //     value1 = true;
  //   } else {
  //     value2 = true;
  //   }
  // }

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
    final customerId = ModalRoute.of(context).settings.arguments;

    if (customerId != null) {
      await Provider.of<Auth>(context, listen: false)
          .tryAutoLogin()
          .then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<CustomerList>(context, listen: false)
              .updateCustomer(customerId.toString(), _newCustomer, token)
              .then((value) {
            if (value == 201 || value == 200) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Customer details updated'),
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

              // setState(() {
              //   _formKey.currentState.reset();
              //   value1 = false;
              //   value2 = false;
              //   value3 = false;
              // });
            } else {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Failed'),
                  content: Text('Something went wrong Please try again'),
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

      // _formKey.currentState.reset();
      // setState(() {
      //   value = false;
      //   value1 = false;
      // });
    } else {
      try {
        print('here');
        await Provider.of<Auth>(context, listen: false)
            .tryAutoLogin()
            .then((value) {
          if (value == true) {
            var token = Provider.of<Auth>(context, listen: false).token;
            Provider.of<CustomerList>(context, listen: false)
                .addCustomer(_newCustomer, token)
                .then((value) {
              if (value == 201 || value == 200) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Success'),
                    content: Text('New Customer Added'),
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
                _formKey.currentState.reset();
                setState(() {
                  value1 = false;
                  value2 = false;
                });
              }
            });
          }
        });

        //  Provider.of<CustomerList>(context, listen: false).fetchAndSetCustomer();
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured'),
            content: Text('Something Went Wrong'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E212D),
        title: Text('Add Customer'),
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
                          Text('Please Enter The details of the Customer'),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['id'],
                            decoration: InputDecoration(labelText: 'Id'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: value,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['name'],
                            decoration: InputDecoration(
                              labelText: 'Customer Name*',
                            ),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: value,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide a Name';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: _initValues['mobile'],
                            decoration:
                                InputDecoration(labelText: 'Mobile Number*'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: int.parse(
                                  value,
                                ),
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
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
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['smartCardNumber'],
                            decoration: InputDecoration(
                                labelText: 'SmartCard Number/VCN*'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: value,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
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
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['area'],
                            decoration: InputDecoration(labelText: 'Area*'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: value,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide a Area';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['node'],
                            decoration: InputDecoration(labelText: 'Node*'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: value,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide Node';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['address'],
                            decoration: InputDecoration(labelText: 'Address*'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: value,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide Node';
                              }
                              //this returning null ensures that there is no error
                              return null;
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['stbId'],
                            decoration: InputDecoration(labelText: 'StbId'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: value,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['tv'],
                            decoration: InputDecoration(labelText: 'Tv'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: value,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['packages'],
                            decoration: InputDecoration(labelText: 'Packages'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: value,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['packageAmount'],
                            decoration: InputDecoration(
                                labelText: 'PackageAmount(Total)'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: value,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['emailId'],
                            decoration: InputDecoration(labelText: 'EmailId'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: value,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['aadharnumber'],
                            decoration:
                                InputDecoration(labelText: 'Aadhar Number'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: value,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['stbMaterial'],
                            decoration:
                                InputDecoration(labelText: 'StbMaterial'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: value,
                                due: _newCustomer.due,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['due'],
                            decoration: InputDecoration(labelText: 'Due'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: value,
                                advance: _newCustomer.advance,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          TextFormField(
                            enabled: cusId != null ? false : true,
                            initialValue: _initValues['advance'],
                            decoration: InputDecoration(labelText: 'Advance'),
                            onSaved: (value) {
                              _newCustomer = Customer(
                                id: _newCustomer.id,
                                name: _newCustomer.name,
                                mobile: _newCustomer.mobile,
                                smartCardNumber: _newCustomer.smartCardNumber,
                                area: _newCustomer.area,
                                node: _newCustomer.node,
                                address: _newCustomer.address,
                                stbId: _newCustomer.stbId,
                                tv: _newCustomer.tv,
                                packages: _newCustomer.packages,
                                packageAmount: _newCustomer.packageAmount,
                                email: _newCustomer.email,
                                aadharnumber: _newCustomer.aadharnumber,
                                stbMaterial: _newCustomer.stbMaterial,
                                due: _newCustomer.due,
                                advance: value,
                                status: _newCustomer.status,
                                subscriptionEndDate:
                                    _newCustomer.subscriptionEndDate,
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text('Status*'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('Active'),
                                        Checkbox(
                                            value: value1,
                                            onChanged: (change) {
                                              if (cusId != null) {
                                                return;
                                              } else {
                                                setState(() {
                                                  value1 = change;
                                                  value2 = false;
                                                  value3 = false;
                                                  _newCustomer = Customer(
                                                    id: _newCustomer.id,
                                                    name: _newCustomer.name,
                                                    mobile: _newCustomer.mobile,
                                                    smartCardNumber:
                                                        _newCustomer
                                                            .smartCardNumber,
                                                    area: _newCustomer.area,
                                                    node: _newCustomer.node,
                                                    address:
                                                        _newCustomer.address,
                                                    stbId: _newCustomer.stbId,
                                                    tv: _newCustomer.tv,
                                                    packages:
                                                        _newCustomer.packages,
                                                    packageAmount: _newCustomer
                                                        .packageAmount,
                                                    email: _newCustomer.email,
                                                    aadharnumber: _newCustomer
                                                        .aadharnumber,
                                                    stbMaterial: _newCustomer
                                                        .stbMaterial,
                                                    due: _newCustomer.due,
                                                    advance:
                                                        _newCustomer.advance,
                                                    status: 'ACTIVE',
                                                    subscriptionEndDate:
                                                        _newCustomer
                                                            .subscriptionEndDate,
                                                  );
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('InActive'),
                                        Checkbox(
                                            value: value2,
                                            onChanged: (change) {
                                              if (cusId != null) {
                                                return;
                                              } else {
                                                setState(() {
                                                  value2 = change;
                                                  value1 = false;
                                                  value3 = false;
                                                  _newCustomer = Customer(
                                                    id: _newCustomer.id,
                                                    name: _newCustomer.name,
                                                    mobile: _newCustomer.mobile,
                                                    smartCardNumber:
                                                        _newCustomer
                                                            .smartCardNumber,
                                                    area: _newCustomer.area,
                                                    node: _newCustomer.node,
                                                    address:
                                                        _newCustomer.address,
                                                    stbId: _newCustomer.stbId,
                                                    tv: _newCustomer.tv,
                                                    packages:
                                                        _newCustomer.packages,
                                                    packageAmount: _newCustomer
                                                        .packageAmount,
                                                    email: _newCustomer.email,
                                                    aadharnumber: _newCustomer
                                                        .aadharnumber,
                                                    stbMaterial: _newCustomer
                                                        .stbMaterial,
                                                    due: _newCustomer.due,
                                                    advance:
                                                        _newCustomer.advance,
                                                    status: 'INACTIVE',
                                                    subscriptionEndDate:
                                                        _newCustomer
                                                            .subscriptionEndDate,
                                                  );
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('STORE'),
                                        Checkbox(
                                            value: value3,
                                            onChanged: (change) {
                                              if (cusId != null) {
                                                return;
                                              } else {
                                                setState(() {
                                                  value3 = change;
                                                  value2 = false;
                                                  value1 = false;
                                                  _newCustomer = Customer(
                                                    id: _newCustomer.id,
                                                    name: _newCustomer.name,
                                                    mobile: _newCustomer.mobile,
                                                    smartCardNumber:
                                                        _newCustomer
                                                            .smartCardNumber,
                                                    area: _newCustomer.area,
                                                    node: _newCustomer.node,
                                                    address:
                                                        _newCustomer.address,
                                                    stbId: _newCustomer.stbId,
                                                    tv: _newCustomer.tv,
                                                    packages:
                                                        _newCustomer.packages,
                                                    packageAmount: _newCustomer
                                                        .packageAmount,
                                                    email: _newCustomer.email,
                                                    aadharnumber: _newCustomer
                                                        .aadharnumber,
                                                    stbMaterial: _newCustomer
                                                        .stbMaterial,
                                                    due: _newCustomer.due,
                                                    advance:
                                                        _newCustomer.advance,
                                                    status: 'STORE',
                                                    subscriptionEndDate:
                                                        _newCustomer
                                                            .subscriptionEndDate,
                                                  );
                                                });
                                              }
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          RaisedButton(
                              color: Colors.black,
                              onPressed: _saveForm,
                              child: Text(
                                'Save Customer',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
