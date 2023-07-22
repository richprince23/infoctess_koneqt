import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class CGPAScreen extends StatefulWidget {
  const CGPAScreen({Key? key}) : super(key: key);

  @override
  CGPAScreenState createState() => CGPAScreenState();
}

class CGPAScreenState extends State<CGPAScreen> {
  int _completedSemesters = 0;
  List<double> _gpas = [];
  double _cgpa = 0.0;
  final TextEditingController _completedSemestersController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String getRemark(double gpa) {
    if (gpa >= 3.5) {
      return 'First Class';
    } else if (gpa >= 3.0) {
      return 'Second Class Upper';
    } else if (gpa >= 2.5) {
      return 'Second Class Lower';
    } else if (gpa >= 2.0) {
      return 'Third Class';
    } else if (gpa >= 1.0) {
      return 'Pass';
    } else {
      return 'Fail';
    }
  }

  @override
  void dispose() {
    _completedSemestersController.dispose();
    _cgpa = 0.0;
    _gpas = [];
    _completedSemesters = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CGPA Calculator'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    controller: _completedSemestersController,
                    decoration: InputDecoration(
                      hintText: 'Enter number of completed semesters',
                      labelText: 'Completed Semesters',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                AppTheme.themeData(false, context).focusColor,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _completedSemesters = int.parse(value);
                        _gpas = List.filled(_completedSemesters, 0.0);
                        inspect(_gpas);
                      });
                    },
                  ),
                ),
                ...List.generate(_gpas.length, (index) {
                  return Container(
                    width: 300,
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value == "") {
                          return 'Please enter a GPA';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter GPA for semester ${index + 1}',
                        labelText: 'GPA for Semester ${index + 1}',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  AppTheme.themeData(false, context).focusColor,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _gpas[index] = double.parse(value);
                        });
                      },
                    ),
                  );
                }),
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      fixedSize: const Size(160, 50),
                      backgroundColor: cPri,
                      foregroundColor: Colors.white,
                      elevation: 0),
                  onPressed: () {
                    if (_formKey.currentState!.validate() == false ||
                        _completedSemesters == 0) {
                      return;
                    } else {
                      setState(() {
                        double totalPoints = 0.0;
                        for (int i = 0; i < _gpas.length; i++) {
                          totalPoints += _gpas[i];
                        }
                        _cgpa = totalPoints / _completedSemesters;
                      });
                      showModalBottomSheet(
                        context: context,
                        builder: ((context) => Container(
                              height: 200,
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'CGPA: ${_cgpa.toStringAsFixed(3)}',
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Class Designation: ${getRemark(_cgpa)}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily:
                                            GoogleFonts.sarabun().fontFamily),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                        fixedSize: const Size(100, 50),
                                        backgroundColor: cPri,
                                        foregroundColor: Colors.white,
                                        elevation: 0),
                                    child: const Text('Close'),
                                  )
                                ],
                              ),
                            )),
                      );
                    }
                  },
                  child: const Text('Calculate CGPA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
