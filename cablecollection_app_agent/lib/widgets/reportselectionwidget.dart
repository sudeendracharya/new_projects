import 'dart:math';

import 'package:cablecollection_app/widgets/monthlyreportwidget.dart';
import 'package:cablecollection_app/widgets/reportallwidget.dart';
import 'package:cablecollection_app/widgets/reportsinglewidget.dart';
import 'package:cablecollection_app/widgets/todaysreportwidget.dart';
import 'package:cablecollection_app/widgets/yearlyreportwidget.dart';
import 'package:flutter/material.dart';

enum ReportLib {
  singleCustomer,
  selectDate,
  todaysReport,
  monthlyReport,
  yearlyReport,
}

class ReportSelectionWidget extends StatefulWidget {
  @override
  _ReportSelectionWidgetState createState() => _ReportSelectionWidgetState();
}

class _ReportSelectionWidgetState extends State<ReportSelectionWidget>
    with AutomaticKeepAliveClientMixin {
  ReportLib _selected = ReportLib.singleCustomer;

  Text selectReport() {
    if (_selected == ReportLib.singleCustomer) {
      return Text(
        'By Customer',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selected == ReportLib.selectDate) {
      return Text(
        'Select Date',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selected == ReportLib.todaysReport) {
      return Text(
        'Todays Report',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selected == ReportLib.monthlyReport) {
      return Text(
        'Monthly Report',
        style: TextStyle(fontSize: 20),
      );
    } else if (_selected == ReportLib.yearlyReport) {
      return Text(
        'Yearly Report',
        style: TextStyle(fontSize: 20),
      );
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: selectReport(),
                  ),
                  PopupMenuButton(
                      elevation: 10,
                      child: Icon(
                        Icons.arrow_drop_down_circle_outlined,
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selected = value;
                        });
                      },
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text('By Customer'),
                              value: ReportLib.singleCustomer,
                            ),
                            PopupMenuItem(
                              child: Text('Select Date'),
                              value: ReportLib.selectDate,
                            ),
                            PopupMenuItem(
                              child: Text('Todays Report'),
                              value: ReportLib.todaysReport,
                            ),
                            PopupMenuItem(
                              child: Text('Monthly Report'),
                              value: ReportLib.monthlyReport,
                            ),
                            PopupMenuItem(
                              child: Text('Yearly Report'),
                              value: ReportLib.yearlyReport,
                            ),
                          ])
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _selected == ReportLib.singleCustomer ? min(280, 400) : 0,
              child: ReportSingleWidget(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _selected == ReportLib.selectDate ? min(350, 400) : 0,
              child: ReportAllWidget(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _selected == ReportLib.todaysReport ? min(350, 400) : 0,
              child: TodaysReportWidget(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _selected == ReportLib.monthlyReport ? min(350, 400) : 0,
              child: MonthlyReportWidget(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _selected == ReportLib.yearlyReport ? min(350, 400) : 0,
              child: YearlyReportWidget(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
