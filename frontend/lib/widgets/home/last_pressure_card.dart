import 'package:flutter/material.dart';

class LastPressureCard extends StatelessWidget {
  final String lastPressure;

  const LastPressureCard({
    super.key,
    required this.lastPressure,
  });

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