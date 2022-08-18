import 'package:cablecollection_app/providers/report.dart';
import 'package:cablecollection_app/providers/reportlist.dart';
import 'package:cablecollection_app/screens/edit_report_screen.dart';
import 'package:cablecollection_app/widgets/SearchWidget.dart';
import 'package:cablecollection_app/widgets/reportselectionwidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({Key key}) : super(key: key);

  static const routeName = '/ReportScreen';

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Report> singleCustomerList;
  List<Report> todaysReportlist;
  List<Report> monthlyReportlist;
  static List<Report> yearlyReportlist;
  List<Report> reportList;
  var value1;
  String query = '';
  int defaultRowsPerPage = 10;
  var isloading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    yearlyReportlist = Provider.of<ReportList>(context).yearlyReportListData;
    if (yearlyReportlist.isNotEmpty) {
      setState(() {});
    }
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Filter-SCN Number',
        onChanged: searchBook,
      );

  void searchBook(String query) {
    if (yearlyReportlist.isNotEmpty) {
      final customerbill = Provider.of<ReportList>(context, listen: false)
          .yearlyReportListData
          .where((bill) {
        final scnNumber = bill.scnNumber;
        final billNo = bill.billNo.toLowerCase();
        final searchNumber = query.toLowerCase();

        return scnNumber.contains(searchNumber) ||
            billNo.contains(searchNumber);
      }).toList();
      setState(() {
        this.query = query;
        yearlyReportlist = customerbill;
      });
    }
  }

  Widget yearlyReportList(BuildContext context) {
    // if (query == '') {
    //   final billData = Provider.of<ReportList>(context);
    //   yearlyReportlist = billData.yearlyReportList;
    // }

    return PaginatedDataTable(
      header: buildSearch(),
      source: MyFilteredData(context),
      columns: const [
        DataColumn(
            label:
                Text('BillNo', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('BillDate',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text('Scn/Vcn', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('CustomerName',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('From Date',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text('To Date', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Agent Name',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      onRowsPerPageChanged: (index) {
        setState(() {
          defaultRowsPerPage = index;
        });
      },
      availableRowsPerPage: const <int>[
        10,
        20,
        40,
        60,
        80,
      ],
      //  horizontalMargin: 10,
      rowsPerPage: defaultRowsPerPage,
      showCheckboxColumn: false,
      showFirstLastButtons: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10),
      children: [
        ReportSelectionWidget(),
        CollectionTotalWidget(),
        Divider(),
        yearlyReportList(context),
      ],
    );
  }
}

class CollectionTotalWidget extends StatelessWidget {
  const CollectionTotalWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Collection Total:${Provider.of<ReportList>(context).collectionTotalData}',
            style: TextStyle(fontSize: 30),
          ),
        ],
      ),
    );
  }
}

class MyFilteredData extends DataTableSource {
  MyFilteredData(this.context);
  final List<Report> data = _ReportScreenState.yearlyReportlist;
  var myFormat = DateFormat('d-MM-yyyy');
  BuildContext context;
  bool selected = false;

  @override
  int get selectedRowCount => 0;

  DataRow displayRows(int index) {
    return DataRow(
        onSelectChanged: (value) {
          if (value == true) {
            showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return AlertDialog(
                  title: Text('Alert'),
                  content: Text(
                      'Are you Sure Want to Edit this Customer Report Data'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        //Navigator.of(context).pop();
                      },
                      child: const Text('cancel'),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        // Navigator.of(context).pop();
                        ReportList.buId = data[index].buId;
                        Navigator.of(context)
                            .pushNamed(EditReportScreen.routeName, arguments: {
                          'paidAmount': data[index].amount,
                          'due': data[index].due,
                          'advance': data[index].advance,
                          'days': data[index].days,
                          'billNo': data[index].billNo,
                          'billFrom': myFormat
                              .format(DateTime.parse(data[index].fromDate)),
                          'billTo': myFormat
                              .format(DateTime.parse(data[index].toDate)),
                          'buId': data[index].buId,
                        });
                      },
                      child: const Text('ok'),
                    ),
                  ],
                );
              },
            );
          }

          selected = value;
          print(data[index].buId);
        },
        selected: selected,
        cells: [
          DataCell(Text('${data[index].billNo}')),
          DataCell(Text(myFormat.format(DateTime.parse(data[index].billDate)))),
          DataCell(Text('${data[index].amount}')),
          DataCell(Text('${data[index].scnNumber}')),
          DataCell(Text(data[index].name)),
          DataCell(Text(myFormat.format(DateTime.parse(data[index].fromDate)))),
          DataCell(Text(myFormat.format(DateTime.parse(data[index].toDate)))),
          DataCell(Text(data[index].agentName)),
        ]);
  }

  @override
  DataRow getRow(int index) => displayRows(index);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;
}
