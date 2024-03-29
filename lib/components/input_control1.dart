import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:resize/resize.dart';

class InputControl extends StatefulWidget {
  final TextEditingController? controller;

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

  final Icon? leading;
  final bool? isSearch;
  final double radius;
  final bool isCollapsed;
  final bool? showFilter;

  const InputControl({
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
    this.radius = 30,
    this.leading,
    this.isSearch = false,
    this.onChanged,
    this.isCollapsed = false,
    this.showFilter = false,
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
            height: 5.w,
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
            height: 1.w,
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
              if (widget.onChanged != null && textLength >= 3) {
                widget.onChanged!(value);
              }
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
          maxLines: widget.type == TextInputType.multiline ? 5 : 1,
          minLines: 1,
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
                        : const SizedBox.shrink(),
                  )
                : (widget.showFilter == true
                    ? GestureDetector(
                        onTap: () => {
                          // if (widget.trailing == null)
                        },
                        child: Icon(
                          Icons.tune_sharp,
                          color: Colors.black54,
                          size: 18.sp + 1,
                        ),
                      )
                    : const Icon(Icons.search)),
            // isDense: true,
            hintText: widget.hintText!.toString(),
            hintStyle: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w400,
              fontSize: 16.sp + 1,
            ),
            contentPadding: widget.isCollapsed == false
                ? EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.w,
                  )
                : EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            filled: true,

            isCollapsed: widget.isCollapsed,
            fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: cSec, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(widget.radius.r),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(style: BorderStyle.none),
              borderRadius: BorderRadius.circular(widget.radius.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(widget.radius.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Colors.red, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(widget.radius.r),
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
