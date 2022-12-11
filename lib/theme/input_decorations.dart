import 'package:flutter/material.dart';

InputDecoration textInputDecoration = InputDecoration(
  hintStyle:
      const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
  contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  filled: true,
  fillColor: const Color.fromRGBO(217, 217, 217, 0.6),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, style: BorderStyle.solid),
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
    borderSide:
        const BorderSide(color: Colors.red, width: 1, style: BorderStyle.solid),
    borderRadius: BorderRadius.circular(50),
  ),
);
