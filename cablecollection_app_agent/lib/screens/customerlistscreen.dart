import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer.dart';
import 'package:cablecollection_app/screens/flow_implement.dart';
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
  List<Customer> list;
  List<Customer> customerList = [];
  String query = '';
  var token;
  var initial = true;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchAndSetCustomer(token)
            .then((value) {
          if (value.isNotEmpty) {
            customerList = value;
            reRun();
          }
        });
      }
    });

    super.initState();
  }

  var initval = true;
  var isloading = true;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  Future<void> refreshProducts(BuildContext context) async {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchAndSetCustomer(token)
            .then((value) {
          if (value.isNotEmpty) {
            customerList = value;
            reRun();
          }
        });
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
    final customers = customerList.where((customer) {
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
    customerList.sort((a, b) {
      var aDate = a.subscriptionEndDate;
      var bDate = b.subscriptionEndDate;
      return -bDate.compareTo(aDate);
    });
    setState(() {});
  }

  void sortByScnNumber() {
    customerList.sort((a, b) {
      var aDate = a.smartCardNumber;
      var bDate = b.smartCardNumber;
      return -bDate.compareTo(aDate);
    });
    setState(() {});
  }

  void sortByName() {
    customerList.sort((a, b) {
      var aDate = a.name;
      var bDate = b.name;
      return -bDate.compareTo(aDate);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (query == '') {
      // final customerData = Provider.of<CustomerList>(
      //   context,
      // );
      list = customerList;
    }

    return isloading == true
        ? Center(child: Text('loading Data'))
        : Scaffold(
            backgroundColor: Color(0xFFE4FBFF),
            body: RefreshIndicator(
              onRefresh: () => refreshProducts(context),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  // appBar: AppBar(
                  //   title: Text('Customer list'),
                  // ),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _controller,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // padding: EdgeInsets.only(top: 0),
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      children: [
                        buildSearch(),
                        ListView.builder(
                          controller: _controller,
                          padding: EdgeInsets.only(top: 0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Column(
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
              ),
            ),
            floatingActionButton:
                // Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: 100,
                //     child: FlowImplement()),

                FloatingActionButton.extended(
              backgroundColor: Colors.black87,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 40,
                                width: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
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
                                  borderRadius: BorderRadius.circular(20),
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
                                  borderRadius: BorderRadius.circular(20),
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
              label: Text('Sort By'),
              icon: Icon(Icons.sort),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
