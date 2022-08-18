import 'package:flutter/material.dart';

class SelectAreaToday extends StatefulWidget {
  SelectAreaToday({Key key}) : super(key: key);

  @override
  _SelectAreaTodayState createState() => _SelectAreaTodayState();
}

class _SelectAreaTodayState extends State<SelectAreaToday> {
  static var areaSelected = false;
  static var selectedArea = '';

  @override
  void didChangeDependencies() {
    areaSelected = false;
    selectedArea = '';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width - 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return SelectAreaChipToday(
            key: UniqueKey(),
          );
        },
      ),
    );
  }
}

class SelectAreaChipToday extends StatefulWidget {
  const SelectAreaChipToday({
    Key key,
  }) : super(key: key);

  @override
  State<SelectAreaChipToday> createState() => _SelectAreaChipTodayState();
}

class _SelectAreaChipTodayState extends State<SelectAreaChipToday>
    with AutomaticKeepAliveClientMixin {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InputChip(
          label: Text('data'),
          selected: _isSelected,
          selectedColor: Colors.blue.shade600,
          onSelected: (bool selected) {
            if (_SelectAreaTodayState.areaSelected == false &&
                _isSelected == false) {
              setState(() {
                _isSelected = selected;
                _SelectAreaTodayState.selectedArea = '';
                _SelectAreaTodayState.areaSelected = true;
              });
            } else if (_isSelected == true &&
                _SelectAreaTodayState.areaSelected == true) {
              setState(() {
                _SelectAreaTodayState.areaSelected = false;
                _isSelected = false;
                _SelectAreaTodayState.selectedArea = '';
              });
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
