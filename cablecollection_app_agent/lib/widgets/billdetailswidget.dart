import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillDetailsWidget extends StatelessWidget {
  var cusid;
  final String name;
  final String scnNumber;
  final String amount;
  final String fromDate;
  final String toDate;
  final String billDate;
  final String agentName;

  BillDetailsWidget({
    this.name,
    this.scnNumber,
    this.amount,
    this.fromDate,
    this.toDate,
    this.billDate,
    this.agentName,
  });
  var myFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(myFormat.format(DateTime.parse(billDate))),
            Text(amount),
            Text(scnNumber),
            Text(name),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(agentName),
            Text(
                'from:${myFormat.format(DateTime.parse(fromDate))}-To:${myFormat.format(DateTime.parse(toDate))}')
          ],
        )
      ],
    );
  }
}
