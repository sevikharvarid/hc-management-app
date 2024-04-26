import 'package:flutter/material.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';

class CustomDropdownMenu extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String? labelText;
  final bool? isReadOnly;

  const CustomDropdownMenu({
    super.key,
    this.isReadOnly = false,
    required this.options,
    required this.onChanged,
    required this.labelText,
  });

  @override
  CustomDropdownMenuState createState() => CustomDropdownMenuState();
}

class CustomDropdownMenuState extends State<CustomDropdownMenu> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedOption,
      onChanged: !widget.isReadOnly!
          ? (String? newValue) {
              setState(() {
                _selectedOption = newValue;
              });
              widget.onChanged(newValue!);
            }
          : null,
      items: widget.options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: AppColors.primary),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.primary), // Ganti warna border sesuai kebutuhan
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
