import 'package:flutter/material.dart';

class LastPressureCard extends StatelessWidget {
  final String lastPressure;

  const LastPressureCard({
    Key? key,
    required this.lastPressure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        lastPressure,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }
}