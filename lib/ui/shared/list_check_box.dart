import 'package:flutter/material.dart';

class ListCheckBox extends StatelessWidget {
  const ListCheckBox({Key? key, required this.isSelected, this.size = 30}) : super(key: key);

  final bool isSelected;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        isSelected ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
        color: isSelected ? Colors.green : Colors.blueAccent,
        size: size,
      ),
    );
  }
}
