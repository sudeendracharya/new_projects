import 'package:cablecollection_app/providers/areaList.dart';
import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:cablecollection_app/providers/customer_list.dart';
import 'package:cablecollection_app/widgets/areabuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CollectionOverView extends StatefulWidget {
  CollectionOverView({Key key}) : super(key: key);

  @override
  _CollectionOverViewState createState() => _CollectionOverViewState();
}

class _CollectionOverViewState extends State<CollectionOverView>
    with AutomaticKeepAliveClientMixin<CollectionOverView> {
  List areaList = [];
  List areaData = [];
  int totalActive = 0;
  int totalInactive = 0;
  int totalStore = 0;
  List<Map<String, dynamic>> activeInactive = [];
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<AllCustomerList>(context, listen: false)
            .getLocalCusList()
            .then((value) {
          if (value == false) {
            Provider.of<AllCustomerList>(context, listen: false)
                .fetchAndSetCustomer(token)
                .then((value) {});
          } else {
            print('getting local data');
          }
        });
        Provider.of<AreaList>(context, listen: false)
            .getAreList(
          token,
        )
            .then((value) {
          // areas = value;
          // reRUn();
        });
        Provider.of<CustomerList>(context, listen: false)
            .customerOverViewScreen(token)
            .then((value) {
          if (value != null) {
            areaList = value['areaList'];
            areaData = value['areaDetails'];
            totalActive = value['totalActive'];
            totalInactive = value['totalInactive'];
            totalStore = value['totalStore'];
            activeInactive = value['areaValues'];
            reRun();
          } else {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Something Went Wrong'),
                content: Text('Please Check your Internet Connection'),
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
    });
    super.initState();
  }

  Future<void> refreshProducts(BuildContext context) async {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .customerOverViewScreen(token)
            .then((value) {
          areaList = value['areaList'] == null ? [] : value['areaList'];
          areaData = value['areaDetails'] == null ? [] : value['areaDetails'];
          totalActive = value['totalActive'];
          totalInactive = value['totalInactive'];
          totalStore = value['totalStore'];
          activeInactive =
              value['areaValues'] == null ? [] : value['areaValues'];
          reRun();
        });
      }
    });
  }

  var isloading = true;

  void reRun() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        //  isloading == false
        //     ? Center(child: Text('loading Data'))
        //:
        RefreshIndicator(
      onRefresh: () => refreshProducts(context),
      child: ListView(
        padding: EdgeInsets.only(
          top: 15,
        ),
        children: [
          Card(
            elevation: 8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Hello Rudresh K V',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('inActive'),
                          Text(
                            totalInactive.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Active'),
                          Text(
                            totalActive.toString(),
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Store'),
                          Text(
                            totalStore.toString(),
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          AreaBuilder(
            areaDetails: areaData == null ? [] : areaData,
            areaList: areaList == null ? [] : areaList,
            activeInactive: activeInactive == null ? [] : activeInactive,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
