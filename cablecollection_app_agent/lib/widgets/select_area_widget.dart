import 'package:cablecollection_app/providers/auth.dart';
import 'package:cablecollection_app/providers/clist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectArea extends StatefulWidget {
  SelectArea({Key key}) : super(key: key);
  static List areaList = [];

  @override
  _SelectAreaState createState() => _SelectAreaState();
}

class _SelectAreaState extends State<SelectArea>
    with AutomaticKeepAliveClientMixin {
  static var areaSelected = false;
  static var selectedArea = '';
  var isloading = true;
  List areas = [];

  @override
  void initState() {
    super.initState();
    Provider.of<Auth>(context, listen: false).tryAutoLogin().then((value) {
      if (value == true) {
        var token = Provider.of<Auth>(context, listen: false).token;
        Provider.of<CustomerList>(context, listen: false)
            .getAreList(
          token,
        )
            .then((value) {
          areas = value;
          reRUn();
        });
      }
    });
  }

  void reRUn() {
    setState(() {
      isloading = false;
    });
  }

  @override
  void didChangeDependencies() {
    SelectArea.areaList = [];
    areaSelected = false;
    selectedArea = '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return isloading == true
        ? Container(
            alignment: Alignment.center,
            height: 60,
            width: MediaQuery.of(context).size.width - 50,
            child: Text('loading'),
          )
        : Container(
            height: 60,
            width: MediaQuery.of(context).size.width - 50,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: areas.length,
              itemBuilder: (BuildContext context, int index) {
                return SelectAreaChip(
                  areas: areas,
                  index: index,
                  key: UniqueKey(),
                );
              },
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}

class SelectAreaChip extends StatefulWidget {
  const SelectAreaChip({
    Key key,
    this.index,
    this.areas,
  }) : super(key: key);
  final int index;
  final List areas;
  @override
  State<SelectAreaChip> createState() => _SelectAreaChipState();
}

class _SelectAreaChipState extends State<SelectAreaChip>
    with AutomaticKeepAliveClientMixin {
  bool _isSelected = false;
  @override
  void initState() {
    super.initState();
    if (SelectArea.areaList.contains(widget.areas[widget.index])) {
      _isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InputChip(
          label: Text(widget.areas[widget.index]),
          selected: _isSelected,
          selectedColor: Colors.blue.shade600,
          onSelected: (bool selected) {
            setState(() {
              _isSelected = selected;
              if (selected == true) {
                if (!SelectArea.areaList.contains(widget.areas[widget.index])) {
                  SelectArea.areaList.add(widget.areas[widget.index]);
                  print(SelectArea.areaList);
                } else {
                  SelectArea.areaList.clear();
                  SelectArea.areaList.add(widget.areas[widget.index]);
                  print(SelectArea.areaList);
                }
              } else {
                SelectArea.areaList.remove(widget.areas[widget.index]);
                print(SelectArea.areaList);
              }
            });
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
