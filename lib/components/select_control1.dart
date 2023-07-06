import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';

class SelectControl extends StatefulWidget {
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final List<DropdownMenuItem<String>> items;
  final void Function(String? value)? onChanged;
  final bool showLabel;

  const SelectControl(
      {Key? inputkey,
      this.hintText,
      this.validator,
      required this.items,
      this.showLabel = true,
      this.onChanged})
      : super(key: inputkey);

  @override
  State<SelectControl> createState() => _SelectControlState();
}

class _SelectControlState extends State<SelectControl> {
  late TextInputFormatter formatter;
  int textLength = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel == true)
          SizedBox(
            height: 5.h,
          ),
        if (widget.showLabel == true)
          Text(
            widget.hintText!.toString(),
            style: GoogleFonts.sarabun(
                fontWeight: FontWeight.normal,
                color: Colors.black87,
                fontSize: 16.sp + 1,
                decoration: TextDecoration.none),
          ),
        if (widget.showLabel == true)
          SizedBox(
            height: 1.w,
          ),
        DropdownButtonFormField(
          items: widget.items,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText!,
            hintStyle: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp + 1,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
            filled: true,
            fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: cSec, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(50),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(style: BorderStyle.none),
              borderRadius: BorderRadius.circular(50),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(50),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.red, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
      ],
    );
  }
}
