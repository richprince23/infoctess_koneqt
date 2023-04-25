import 'package:flutter/material.dart';

class Indicator extends StatefulWidget {
  const Indicator({
    Key? key,
    required this.count,
    required this.curIndex,
  }) : super(key: key);

  final int count;
  final int curIndex;

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (int i = 0; i < widget.count; i++)
        if (i == widget.curIndex) IndicatorDot(true) else IndicatorDot(false)
    ]);
  }

  // ignore: non_constant_identifier_names
  Widget IndicatorDot(bool active) {
    return AnimatedContainer(
      // key: Key(active.toString()),
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: active == true ? Colors.pink : Colors.grey,
          borderRadius: BorderRadius.circular(10)),
      duration: const Duration(milliseconds: 200),
    );
  }
}
