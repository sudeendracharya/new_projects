import 'package:flutter/material.dart';

class FlowImplement extends StatefulWidget {
  FlowImplement({Key key}) : super(key: key);

  @override
  _FlowImplementState createState() => _FlowImplementState();
}

class _FlowImplementState extends State<FlowImplement>
    with SingleTickerProviderStateMixin {
  AnimationController _myAnimation;
  IconData lastTapped = Icons.sort;

  final List<IconData> _icons = [
    Icons.sort,
    Icons.format_list_numbered_rounded,
    Icons.person,
    Icons.date_range,
  ];

  @override
  void initState() {
    super.initState();
    _myAnimation =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  void _updateMenu(IconData icon) {
    if (icon != Icons.date_range) {
      setState(() => lastTapped = icon);
    }
  }

  Widget flowMenuItem(IconData icon) {
    final double buttonDiameter =
        MediaQuery.of(context).size.width / _icons.length;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: RawMaterialButton(
        fillColor: lastTapped == icon ? Colors.amber[700] : Colors.blue,
        splashColor: Colors.amber[100],
        shape: const CircleBorder(),
        constraints: BoxConstraints.tight(Size.square(50)),
        onPressed: () {
          _updateMenu(icon);
          _myAnimation.status == AnimationStatus.completed
              ? _myAnimation.reverse()
              : _myAnimation.forward();
        },
        child: Icon(
          icon,
          color: Colors.white,
          size: 45.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(menuAnimation: _myAnimation),
      children:
          _icons.map<Widget>((IconData icon) => flowMenuItem(icon)).toList(),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  FlowMenuDelegate({this.menuAnimation}) : super(repaint: menuAnimation);

  final Animation<double> menuAnimation;

  @override
  bool shouldRepaint(FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    double dx = 0.0;
    for (int i = 0; i < context.childCount; ++i) {
      dx = context.getChildSize(i).height * i;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          0,
          dx * menuAnimation.value,
          0,
        ),
      );
    }
  }
}
