// bottom appBar DropDownMenu For Location
import 'package:flutter/material.dart';

import '../../../../utils/colors.dart';

class dropDownLocationMenu extends StatefulWidget {
  const dropDownLocationMenu({super.key});

  @override
  State<dropDownLocationMenu> createState() => _dropDownLocationMenuState();
}

class _dropDownLocationMenuState extends State<dropDownLocationMenu> {
  String? _selectedItem;
  final List<String> _dropdownItems = [
    'Your Loction',
    'Karachi',
    'Lahore',
    'Islamabad',
    'Hyderabad'
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Spacer(),
          const Icon(Icons.location_on, size: 18,),
          DropdownButton<String>(
            value: _selectedItem,
            hint: const Text('Location'),
            style: TextStyle(color: blueColor),
            items: _dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedItem = newValue!;
              });
            },
          ),
        ],
      ),
    );
  }
}
