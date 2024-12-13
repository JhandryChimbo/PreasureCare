import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;

  const ConfirmButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.foregroundColor = Colors.white,
    this.backgroundColor = const Color(0xFF2897FF),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}

class NegativeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;

  const NegativeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.foregroundColor = Colors.white,
    this.backgroundColor = const Color(0xFFFF0000),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
