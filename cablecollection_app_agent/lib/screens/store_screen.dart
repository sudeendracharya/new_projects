import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({Key key}) : super(key: key);

  static const routeName = '/StoreScreen';

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List storeData = [];
  var isloading = true;
  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .fetchAndSetCustomerStore(token)
            .then((value) {
          storeData = value;
          reRun();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Store'),
        ),
        body: isloading == true
            ? Center(child: CircularProgressIndicator())
            : storeData.isEmpty
                ? Center(child: Text('No Data to display'))
                : Container());
  }
}
