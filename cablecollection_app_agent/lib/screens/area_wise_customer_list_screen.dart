import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer.dart';
import 'package:cablecollection_app/widgets/SearchWidget.dart';
import 'package:cablecollection_app/widgets/customerdatawidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AreaWiseCustomerList extends StatefulWidget {
  AreaWiseCustomerList({Key key}) : super(key: key);

  static const routeName = '/AreaWiseCustomerList';

  @override
  _AreaWiseCustomerListState createState() => _AreaWiseCustomerListState();
}

class _AreaWiseCustomerListState extends State<AreaWiseCustomerList> {
  var isloading = true;
  var areaName;
  List<Customer> customerListData = [];
  List<Customer> list = [];
  String query = '';
  ScrollController _controller = ScrollController();

  Future<void> refreshProducts(BuildContext context) async {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var areaName = Customer.areaName;
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .getAreaWiseCustomerList(areaName, token)
            .then((value) {
          if (value.isNotEmpty) {
            customerListData = value;
            reRun();
          }
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    areaName = ModalRoute.of(context).settings.arguments;
    if (areaName != null) {
      Customer.areaName = areaName;
      Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
        if (value == true) {
          var token = Provider.of<Auth>(context, listen: false).token;
          Provider.of<CustomerList>(context, listen: false)
              .getAreaWiseCustomerList(areaName, token)
              .then((value) {
            if (value.isNotEmpty) {
              customerListData = value;
              reRun();
            }
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    final customers = customerListData.where((customer) {
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

  @override
  Widget build(BuildContext context) {
    if (query == '') {
      // final customerData = Provider.of<CustomerList>(
      //   context,
      // );
      list = customerListData;
    }
    return Scaffold(
      appBar: AppBar(
        title: areaName == null
            ? Text('Customer List')
            : Text(areaName.toString()),
        backgroundColor: Colors.black,
      ),
      body: isloading == true
          ? Center(
              child: Text('Loading data'),
            )
          : RefreshIndicator(
              onRefresh: () => refreshProducts(context),
              child: Scrollbar(
                controller: _controller,
                interactive: true,
                showTrackOnHover: true,
                isAlwaysShown: true,
                hoverThickness: 30,
                radius: Radius.circular(10),
                child: ListView(
                  children: [
                    buildSearch(),
                    ListView.builder(
                      controller: _controller,
                      padding: EdgeInsets.only(top: 0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
    );
  }
}
