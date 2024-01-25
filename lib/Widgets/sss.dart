import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Indicator extends StatefulWidget {
  final double percent;
  final Text center;
  const Indicator({super.key,
    required this.percent,
    required this.center});

  @override
  State<Indicator> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircularPercentIndicator(
        linearGradient: LinearGradient(
            colors: [Colors.indigo[300] as Color, Colors.indigo[700] as Color ]),
        arcType: ArcType.FULL,
        curve: Curves.easeInCubic,
        arcBackgroundColor: Colors.indigo[100],
        animateFromLastPercent: true,
        backgroundColor: Colors.indigo[100] as Color,
        circularStrokeCap: CircularStrokeCap.round,
        percent: widget.percent,  //calculateCompletionRatio(habitBox.values.toList()),
        lineWidth: 15,
        radius: 60,
        animation: true,
        center: widget.center,

      ),
    );
  }
}
