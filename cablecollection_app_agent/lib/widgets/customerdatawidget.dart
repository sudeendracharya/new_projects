import 'package:cablecollection_app/screens/customerdetailsscreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomerDataWidget extends StatefulWidget {
  final String mobileNumber;
  final String name;
  final String scnNumber;
  final String cusId;
  var status;
  var subEndDate = '';

  CustomerDataWidget(
    Key key,
    this.mobileNumber,
    this.name,
    this.scnNumber,
    this.cusId,
    this.subEndDate,
    this.status,
  );

  @override
  _CustomerDataWidgetState createState() => _CustomerDataWidgetState();
}

class _CustomerDataWidgetState extends State<CustomerDataWidget> {
  var myFormat = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(CustomerDetailsScreen.routeName,
              arguments: widget.cusId);
        },
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.black, fontSize: 15),
            children: [
              TextSpan(
                // style: TextStyle(fontSize: 15),
                text: 'Mobile Number:${widget.mobileNumber}\n',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Clipboard.setData(
                            new ClipboardData(text: widget.mobileNumber))
                        .then(
                      (_) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            // duration: Duration(milliseconds: 100),
                            content: Text("Mobile Number copied to clipboard"),
                          ),
                        );
                      },
                    );
                  },
              ),
              TextSpan(
                text: 'ScnNo:${widget.scnNumber}\n',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Clipboard.setData(
                      new ClipboardData(text: widget.scnNumber),
                    ).then(
                      (_) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Box Number copied to clipboard"),
                          ),
                        );
                      },
                    );
                  },
              ),
            ],
          ),
        ),
        isThreeLine: true,
        trailing: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  style: TextStyle(color: Colors.black),
                  text: widget.subEndDate == 'No End Date' ||
                          widget.subEndDate == null
                      ? 'No SubEnd Date\n'
                      : '${myFormat.format(DateTime.parse(widget.subEndDate))}\n'),
              TextSpan(
                text: widget.status == 'ACTIVE'
                    ? 'Active'
                    : widget.status == 'INACTIVE'
                        ? 'InActive'
                        : 'Store',
                style: TextStyle(
                  color: widget.status == 'ACTIVE'
                      ? Colors.green
                      : widget.status == 'INACTIVE'
                          ? Colors.red
                          : Colors.yellow,
                ),
              )
            ],
          ),
        ));
  }
}
