import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class LiquidIndicator extends StatefulWidget {
  final Text centertext;
  final double value;
  const LiquidIndicator({super.key,
    required this.value,
    required this.centertext});

  @override
  State<LiquidIndicator> createState() => _LiquidIndicatorState();
}

class _LiquidIndicatorState extends State<LiquidIndicator> {
  @override
  Widget build(BuildContext context) {
    return LiquidLinearProgressIndicator(
      center: widget.centertext,
      borderRadius: 12,
      value: widget.value,
      valueColor: AlwaysStoppedAnimation(Colors.indigo),
      backgroundColor: Colors.indigo[100],
      direction: Axis.horizontal,
    );
  }
}
