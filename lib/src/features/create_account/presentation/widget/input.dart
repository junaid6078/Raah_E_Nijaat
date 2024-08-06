
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../app/utils/colors.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final Key? fieldKey;
  final bool? isPassword;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFileSubmitted;
  final TextInputType? inputType;
  final IconData icon;
  final bool obscureText;

  const Input({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    required this.controller,
    this.fieldKey,
    this.isPassword,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFileSubmitted,
    this.inputType,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword == true ? obscureText : false,
      keyboardType: widget.inputType,
      key: widget.fieldKey,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFileSubmitted,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(widget.icon, color: Colors.white70),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: widget.isPassword == true
              ? Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: obscureText == false ? yellowColor : Colors.white70,
          )
              : const Text(""),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
