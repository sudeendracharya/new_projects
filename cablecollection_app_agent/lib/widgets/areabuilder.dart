import 'dart:math';

import 'package:cablecollection_app/screens/area_wise_customer_list_screen.dart';
import 'package:cablecollection_app/screens/node_wise_customer_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AreaBuilder extends StatefulWidget {
  AreaBuilder({
    Key key,
    @required this.areaList,
    @required this.areaDetails,
    @required this.activeInactive,
  }) : super(key: key);

  final List areaList;
  final List areaDetails;
  List<Map<String, dynamic>> activeInactive = [];

  @override
  _AreaBuilderState createState() => _AreaBuilderState();
}

class _AreaBuilderState extends State<AreaBuilder> {
  @override
  Widget build(BuildContext context) {
    // areaList = Provider.of<CustomerList>(context).areaListData;
    // areaDetails = customerList.areaDetailsData;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: 10,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.areaList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListView(
              padding: EdgeInsets.only(top: 5),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AreaWiseCustomerList.routeName,
                        arguments: widget.areaList[index],
                      );
                    },
                    child: Container(
                      height: 20,
                      child: Text(
                        widget.areaList[index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text('inactive'),
                            Text(
                              widget.activeInactive[index]['inactive']
                                  .toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('active'),
                            Text(
                              widget.activeInactive[index]['active'].toString(),
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('store'),
                            Text(
                              widget.activeInactive[index]['store'].toString(),
                              style: TextStyle(color: Colors.yellow),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                AreaAgents(widget.areaList[index], widget.areaDetails),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AreaAgents extends StatefulWidget {
  AreaAgents(this.area, this.areaDetails);
  var area;
  final List areaDetails;
  @override
  _AreaAgentsState createState() => _AreaAgentsState();
}

class _AreaAgentsState extends State<AreaAgents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.areaDetails.length,
      itemBuilder: (BuildContext context, int index) {
        return widget.area == widget.areaDetails[index]['Area']
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(NodeWiseCustomerList.routeName, arguments: {
                    'areaName': widget.area,
                    'node': widget.areaDetails[index]['Node']
                  });
                },
                child: IndividualAgent(
                  node: widget.areaDetails[index]['Node'].toString(),
                  active: widget.areaDetails[index]['Active'].toString(),
                  inActive: widget.areaDetails[index]['InActive'].toString(),
                  store: widget.areaDetails[index]['Store'].toString(),
                ),
              )
            : SizedBox();
      },
    );
  }
}

class IndividualAgent extends StatefulWidget {
  final String node;
  final String active;
  final String inActive;
  final String store;

  const IndividualAgent(
      {Key key,
      @required this.node,
      @required this.active,
      @required this.inActive,
      @required this.store})
      : super(key: key);

  @override
  _IndividualAgentState createState() => _IndividualAgentState();
}

class _IndividualAgentState extends State<IndividualAgent> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      child: Column(children: [
        Container(
          //elevation: 3,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: ListTile(
              //leading: Text('name'),
              title: Text(widget.node),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          height: _expanded ? min(50, 100) : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('inactive'),
                  Text(
                    widget.inActive,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('active'),
                  Text(
                    widget.active,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              Column(
                children: [
                  Text('store'),
                  Text(
                    widget.store,
                    style: TextStyle(color: Colors.yellow),
                  ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}
