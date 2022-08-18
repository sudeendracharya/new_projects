import 'dart:ui';

import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer.dart';

import 'package:cablecollection_app/screens/addcustomerscreen.dart';
import 'package:cablecollection_app/screens/billingscreen.dart';
import 'package:cablecollection_app/screens/individual_customer_complaint_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsScreen extends StatefulWidget {
  static const routeName = '/CustomerDetails';

  @override
  _CustomerDetailsScreenState createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  var initVal = true;

  Map<String, dynamic> customerData;

  var cusData;
  var isloading = true;
  var customerId;
  var myFormat = DateFormat('d-MM-yyyy');

  var initValues = {
    'id': '',
    'name': '',
    'smartcard': '',
    'mobile': '',
    'packAmount': '',
    'stbId': '',
    'tv': '',
    'packages': '',
    'address': '',
    'area': '',
    'node': '',
    'subscriptionEndDate': '',
    'Status': '',
  };

  @override
  void didChangeDependencies() {
    if (initVal == true) {
      customerId = ModalRoute.of(
        context,
      ).settings.arguments;
      if (customerId != null) {
        Customer.customerId = customerId;
        Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
          if (value == true) {
            var token = Provider.of<Auth>(context, listen: false).token;
            Provider.of<CustomerList>(context, listen: false)
                .fetchCustomerDetails(customerId, token)
                .then((value) {
              if (value != null) {
                customerData = value;
                // print(customerData.toString());

                setState(() {
                  initValues = {
                    'id': value['id'],
                    'name': value['Name'],
                    'smartcard': value['SmartCardNumber'],
                    'mobile': value['Mobile'].toString(),
                    'packAmount': value['PackageAmount'],
                    'stbId': value['StbId'],
                    'tv': value['TV'],
                    'packages': value['Packages'],
                    'address': value['Address'],
                    'area': value['Area'],
                    'node': value['Node'],
                    'subscriptionEndDate': value['SubscriptionEndDate'],
                    'Status': value['Status'],
                  };
                });
                reRun();
              }
            });
          }
        });
      }
      initVal = false;
    }

    super.didChangeDependencies();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  void deleteCustomer() {
    try {
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<CustomerList>(context, listen: false)
              .deleteCustomer(Customer.customerId.toString(), token)
              .then((value) {
            if (value == 200 || value == 201 || value == 204) {
              dialogWidget(context);
            } else {
              dialogFailureWidget(context);
            }
          });
        }
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctxx) => AlertDialog(
          title: Text('Success'),
          content: Text('Deletion of Customer Unsuccessful'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(ctxx).pop();
                // Navigator.of(context).pop();
              },
              child: Text('ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cusId = ModalRoute.of(context).settings.arguments;
    // final scaffold = Scaffold.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E212D),
        title: Text('Customer Details'),
      ),
      body: isloading == true
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '${initValues['name']}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Id: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${initValues['id']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //  alignment: Alignment.topLeft,
                              child: Text(
                                'Smartcard Number:',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              // alignment: Alignment.topLeft,
                              child: Text(
                                ' ${initValues['smartcard']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // alignment: Alignment.topLeft,
                              child: Text(
                                'Mobile Number: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              // alignment: Alignment.topLeft,
                              child: Text(
                                '${initValues['mobile']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'PackageAmount: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${initValues['packAmount']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'StbId: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${initValues['stbId']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Tv: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${initValues['tv']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Package: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${initValues['packages']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Address:',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                ' ${initValues['address']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Area: ',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                '${initValues['area']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                'Node:',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Container(
                              child: Text(
                                ' ${initValues['node']}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Text('SubscriptionEndDate:',
                                    style: TextStyle(fontSize: 18))),
                            Container(
                              child: initValues['subscriptionEndDate'] == null
                                  ? Text(' Not Available')
                                  : Text(
                                      '${myFormat.format(DateTime.parse(initValues['subscriptionEndDate']))}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status:',
                                style: TextStyle(fontSize: 18),
                              ),
                              initValues['Status'].toString() == 'ACTIVE'
                                  ? SizedBox(
                                      height: 40,
                                      width: 80,
                                      child: Card(
                                        color: Colors.green,
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Active',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            )),
                                      ),
                                    )
                                  : initValues['Status'].toString() ==
                                          'INACTIVE'
                                      ? SizedBox(
                                          height: 40,
                                          width: 80,
                                          child: Card(
                                            color: Colors.red,
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'InActive',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 40,
                                          width: 80,
                                          child: Card(
                                            color: Colors.yellow,
                                            child: Container(
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Store',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                )),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          thickness: 5,
                          color: Color(0xFF1E212D),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // bool res = await FlutterPhoneDirectCaller.callNumber(
                                    //     initValues['mobile'].toString());
                                    String number =
                                        'tel:${initValues['mobile'].toString()}';
                                    launch(number);
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Container(
                                      child: Image.asset(
                                        'assets/images/telephone.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text('call'),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        BillingScreen.routeName,
                                        arguments: customerId);
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Container(
                                      child: Image.asset(
                                        'assets/images/bill.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text('Billing')
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        AddCustomerScreen.routeName,
                                        arguments: cusId);
                                    // setState(() {});
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Container(
                                      child: Image.asset(
                                        'assets/images/edit1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text('Edit')
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // bool res = await FlutterPhoneDirectCaller.callNumber(
                                    //     initValues['mobile'].toString());
                                    String number =
                                        'sms:${initValues['mobile'].toString()}';
                                    launch(number);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Container(
                                        child: Image.asset(
                                          'assets/images/smartphone.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text('SMS'),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // bool res = await FlutterPhoneDirectCaller.callNumber(
                                    //     initValues['mobile'].toString());
                                    Navigator.of(context).pushNamed(
                                        IndividualCustomerComplaint.routeName,
                                        arguments: customerId);
                                  },
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Container(
                                      child: Image.asset(
                                        'assets/images/complaints.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Text('Complaint')
                              ],
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                            ),
                            // Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         try {
                            //           showDialog(
                            //             context: context,
                            //             builder: (ctx) => AlertDialog(
                            //               title: Text('Delete'),
                            //               content: Text(
                            //                   'Are you sure want to Delete this Customer'),
                            //               actions: [
                            //                 FlatButton(
                            //                   onPressed: deleteCustomer,
                            //                   child: const Text('ok'),
                            //                 ),
                            //                 FlatButton(
                            //                   onPressed: () {
                            //                     Navigator.of(ctx).pop();
                            //                   },
                            //                   child: Text('Cancel'),
                            //                 ),
                            //               ],
                            //             ),
                            //           );
                            //         } catch (error) {}
                            //       },
                            //       child: SizedBox(
                            //         height: 50,
                            //         width: 50,
                            //         child: Container(
                            //           child: Image.asset(
                            //             'assets/images/bin.png',
                            //             fit: BoxFit.cover,
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     Text('Delete')
                            //   ],
                            // ),
                          ],
                        ),

                        SizedBox(
                          height: 60,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<dynamic> dialogFailureWidget(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctxx) => AlertDialog(
        title: Text('Failed'),
        content: Text('Deletion of Customer Unsuccessful'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctxx).pop();
              // Navigator.of(context).pop();
            },
            child: Text('ok'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> dialogWidget(BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctxx) => AlertDialog(
        title: Text('Success'),
        content: Text('Deleted Customer Successfully'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctxx).pop();
              Navigator.of(context).pop();
            },
            child: Text('ok'),
          ),
        ],
      ),
    );
  }
}
