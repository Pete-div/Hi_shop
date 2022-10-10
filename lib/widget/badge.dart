import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({required this.child, required this.value, this.color});
  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.red),
            constraints: BoxConstraints(minHeight: 16, minWidth: 16),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
