import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';
import 'package:resize/resize.dart';

class InputControl extends StatefulWidget {
  TextEditingController? controller;

  final String? hintText;

  final bool? isPassword;
  final TextInputType? type;
  final bool? showLabel;
  final FocusNode? focusNode;
  // final IconData? suffixIcon;

  final FormFieldValidator<String>? validator;

  final bool? readOnly;

  final void Function()? onTap;
  final void Function(String)? onChanged;

  Icon? leading;
  bool? isSearch;

  InputControl({
    Key? inputkey,
    this.type,
    this.hintText,
    this.isPassword,
    this.readOnly,
    this.controller,
    this.validator,
    this.onTap,
    this.showLabel = true,
    this.focusNode,
    this.leading,
    this.isSearch = false,
    this.onChanged,
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
    // var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
            overflow: TextOverflow.ellipsis,
          ),
        if (widget.showLabel == true)
          SizedBox(
            height: 10.h,
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
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (widget.onChanged != null) widget.onChanged!(value);
            }
                // widget.onChanged(value),
                )
          },
          textInputAction: (widget.isSearch == true)
              ? TextInputAction.search
              : widget.type == TextInputType.multiline
                  ? TextInputAction.newline
                  : TextInputAction.next,
          onTap: widget.onTap,
          validator: widget.validator,
          keyboardType: widget.type ?? TextInputType.text,
          obscureText: showPass,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textCapitalization: TextCapitalization.sentences,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            fontSize: 16.sp + 1,
          ),
          decoration: InputDecoration(
            prefixIcon: widget.leading,
            // suffixIcon: widget.trailing,
            suffixIcon: widget.isSearch == false
                ? GestureDetector(
                    onTap: () => {
                      // if (widget.trailing == null)
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
                        ? Icon(
                            CupertinoIcons.clear_circled,
                            color: cSec,
                            size: 18.sp + 1,
                          )
                        : const Icon(null),
                  )
                : GestureDetector(
                    onTap: () => {
                      // if (widget.trailing == null)
                      print("Filter")
                    },
                    child: Icon(
                      Icons.tune_sharp,
                      color: Colors.black54,
                      size: 18.sp + 1,
                    ),
                  ),
            // isDense: true,
            hintText: widget.hintText!.toString(),
            hintStyle: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp + 1,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 10.h,
            ),
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
          height: 5.h,
        ),
      ],
    );
  }
}
