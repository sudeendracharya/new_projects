import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/screens/addcustomerscreen.dart';
import 'package:cablecollection_app/screens/complaints_screen.dart';
import 'package:cablecollection_app/screens/store_screen.dart';
import 'package:cablecollection_app/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerContainer extends StatelessWidget {
  const DrawerContainer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF1E212D)),
            child: Container(
                //  color: Color(0xFFB61919),
                alignment: Alignment.center,
                child: Text(
                  'welcome',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                )),
          ),
          Divider(),
          SizedBox(
            height: 5,
          ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.person),
          //     title: Text('Add Customer'),
          //     onTap: () {
          //       Navigator.of(context).pushNamed(AddCustomerScreen.routeName);
          //     },
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     leading: Icon(Icons.support_agent_sharp),
          //     title: Text('Agent'),
          //   ),
          // ),
          // Card(
          //   child: ListTile(
          //     onTap: () {
          //       Navigator.of(context).pushNamed(StoreScreen.routeName);
          //     },
          //     leading: Icon(Icons.store),
          //     title: Text('Store'),
          //   ),
          // ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(TodoScreen.routeName);
              },
              leading: Icon(Icons.bar_chart),
              title: Text('To-Do'),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(Complaints.routeName);
              },
              leading: Icon(Icons.add_alert_outlined),
              title: Text('Complaints'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
