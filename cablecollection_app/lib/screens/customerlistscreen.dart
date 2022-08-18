import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/customer.dart';
import 'package:cablecollection_app/providers/customer_list.dart';
import 'package:cablecollection_app/widgets/SearchWidget.dart';
import 'package:cablecollection_app/widgets/customerdatawidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerListScreen extends StatefulWidget {
  CustomerListScreen({Key key}) : super(key: key);

  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen>
    with AutomaticKeepAliveClientMixin<CustomerListScreen> {
  List actualList = [];
  List<Customer> list;
  List<Customer> customerList = [];
  String query = '';
  var token;
  var initial = true;

  ScrollController _scrollController = ScrollController();
  @override
  // void initState() {
  //   Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
  //     if (value == true) {
  //       token = Provider.of<Auth>(context, listen: false).token;
  //       Provider.of<AllCustomerList>(context, listen: false)
  //           .getLocalCusList()
  //           .then((value) {
  //         if (value == false) {
  //           Provider.of<AllCustomerList>(context, listen: false)
  //               .fetchAndSetCustomer(token)
  //               .then((value) {});
  //         }
  //       });
  //     }
  //   });

  // void listenScrolling() {
  //   setState(() {
  //     if (_scrollController.offset >= 800) {
  //       _showBackToTopButton = true; // show the back-to-top button
  //     } else {
  //       _showBackToTopButton = false; // hide the back-to-top button
  //     }
  //   });
  // }

  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
    // _scrollController.jumpTo(0);
  }

  //   super.initState();
  // }

  var initval = true;
  var isloading = true;
  var loadContent = false;

  void reRun() {
    setState(() {
      isloading = false;
      loadContent = false;
    });
  }

  void refreshProducts(BuildContext context) async {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        setState(() {
          list.clear();
        });
        token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<AllCustomerList>(context, listen: false)
            .fetchAndSetCustomer(token)
            .then((value) {});
      }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   //if (initval == true) {
  //   Provider.of<CustomerList>(context, listen: false).fetchAndSetCustomer();
  //   // }
  //   //initval = false;

  //   super.didChangeDependencies();
  // }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    final customers = actualList.where((customer) {
      final cusNumber = customer.mobile.toString();
      final scnNumber = customer.smartCardNumber;
      final name = customer.name.toLowerCase();
      final searchNumber = query.toLowerCase();

      return cusNumber.contains(searchNumber) ||
          scnNumber.contains(searchNumber) ||
          name.contains(searchNumber);
    }).toList();

    setState(() {
      this.query = query;
      this.list = customers;
    });
  }

  void sortByDate() {
    actualList.sort((a, b) {
      var aDate = a.subscriptionEndDate;
      var bDate = b.subscriptionEndDate;
      return -bDate.compareTo(aDate);
    });
    setState(() {});
  }

  void sortByScnNumber() {
    actualList.sort((a, b) {
      var aDate = a.smartCardNumber;
      var bDate = b.smartCardNumber;
      return -bDate.compareTo(aDate);
    });
    setState(() {});
  }

  void sortByName() {
    actualList.sort((a, b) {
      var aDate = a.name;
      var bDate = b.name;
      return -bDate.compareTo(aDate);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (query == '') {
      actualList = Provider.of<AllCustomerList>(
        context,
      ).customerList;
      list = actualList;
    }

    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // padding: EdgeInsets.only(top: 0),
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: buildSearch(),
                  ),
                  list.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            refreshProducts(context);
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            refreshProducts(context);
                          },
                          icon: Icon(
                            Icons.run_circle_rounded,
                            size: 30,
                          )),
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Color(0xFFE4FBFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 10,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 40,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                sortByName();
                                              },
                                              child: Text('Name')),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                sortByScnNumber();
                                              },
                                              child: Text('Scn Number')),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 120,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.black)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                sortByDate();
                                              },
                                              child: Text('Expiry Date')),
                                        ),
                                      ),
                                    ],
                                  ));
                            });
                      },
                      icon: Icon(
                        Icons.sort_rounded,
                        size: 30,
                      ))
                ],
              ),
              list.isEmpty
                  // isloading == true
                  ? Center(child: SizedBox())
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 0),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        // padding: EdgeInsets.only(top: 0),
                        // shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        children: [
                          CustomerDataWidget(
                            UniqueKey(),
                            list[index].mobile.toString(),
                            list[index].name,
                            list[index].smartCardNumber,
                            list[index].cuId,
                            list[index].subscriptionEndDate,
                            list[index].status,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton:
          // _showBackToTopButton == false
          //     ? null
          //     :
          FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _scrollToTop,
        child: Icon(Icons.arrow_upward),
      ),
    );
    // floatingActionButton:
    //     // Container(
    //     //     width: MediaQuery.of(context).size.width,
    //     //     height: 100,
    //     //     child: FlowImplement()),

    //     FloatingActionButton.extended(
    //   backgroundColor: Colors.black87,
    //   onPressed: () {
    //     showModalBottomSheet(
    //         backgroundColor: Color(0xFFE4FBFF),
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(10.0),
    //         ),
    //         elevation: 10,
    //         context: context,
    //         builder: (BuildContext context) {
    //           return Container(
    //               height: 80,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   SizedBox(
    //                     height: 40,
    //                     width: 120,
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(20),
    //                       child: ElevatedButton(
    //                           style: ButtonStyle(
    //                               backgroundColor: MaterialStateProperty.all(
    //                                   Colors.black)),
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                             sortByName();
    //                           },
    //                           child: Text('Name')),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 40,
    //                     width: 120,
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(20),
    //                       child: ElevatedButton(
    //                           style: ButtonStyle(
    //                               backgroundColor: MaterialStateProperty.all(
    //                                   Colors.black)),
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                             sortByScnNumber();
    //                           },
    //                           child: Text('Scn Number')),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     height: 40,
    //                     width: 120,
    //                     child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(20),
    //                       child: ElevatedButton(
    //                           style: ButtonStyle(
    //                               backgroundColor: MaterialStateProperty.all(
    //                                   Colors.black)),
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                             sortByDate();
    //                           },
    //                           child: Text('Expiry Date')),
    //                     ),
    //                   ),
    //                 ],
    //               ));
    //         });
    //   },
    //   label: Text('Sort By'),
    //   icon: Icon(Icons.sort),
    // ),
  }

  @override
  bool get wantKeepAlive => true;
}
