import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class InputControl extends StatefulWidget {
  final TextEditingController? controller;

  final String? hintText;

  final bool? isPassword;
  final TextInputType? type;
  // final IconData? suffixIcon;

  final FormFieldValidator<String>? validator;

  final bool? readOnly;

  const InputControl({
    Key? inputkey,
    this.type,
    this.hintText,
    this.isPassword,
    this.readOnly,
    this.controller,
    this.validator,
  }) : super(key: inputkey);

  @override
  State<InputControl> createState() => _InputControlState();
}

class _InputControlState extends State<InputControl> {
  late TextInputFormatter formatter;
  int textLength = 0;
  @override
  Widget build(BuildContext context) {
    bool showPass = widget.isPassword ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          widget.hintText!.toString().capitalized() ,
          style: GoogleFonts.sarabun(
              fontWeight: FontWeight.normal,
              color: Colors.black87,
              fontSize: 18,
              decoration: TextDecoration.none),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          readOnly: widget.readOnly ?? false,
          inputFormatters: [
            if (widget.type == TextInputType.phone)
              FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (value) => {
            setState(() {
              textLength = value.length;
            }),
            
          },
          validator: widget.validator,
          keyboardType: widget.type ?? TextInputType.text,
          obscureText: showPass,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () => {
                setState(
                  () {
                    if (widget.controller != null) {
                      widget.controller!.clear();
                      textLength = 0;
                    }
                  },
                )
              },
              child: textLength > 0
                  ? const Icon(
                      CupertinoIcons.clear_circled,
                      color: Colors.red,
                    )
                  : const Icon(null),
            ),
            hintText: "your ${widget.hintText!.toLowerCase()}",
            hintStyle: const TextStyle(
                color: Colors.black54, fontWeight: FontWeight.w400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            filled: true,
            fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: AppTheme.themeData(false, context).focusColor,
                  width: 1,
                  style: BorderStyle.solid),
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
