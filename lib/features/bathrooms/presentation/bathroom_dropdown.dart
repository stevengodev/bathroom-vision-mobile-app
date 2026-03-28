import 'package:flutter/material.dart';

class BathroomDropdown<T> extends StatelessWidget {
  final String label;
  final T? initialValue;
  final List<T> items;
  final String Function(T) getLabel;
  final void Function(T?)? onChanged;

  const BathroomDropdown({
    super.key,
    required this.label,
    required this.initialValue,
    required this.items,
    required this.getLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(getLabel(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}