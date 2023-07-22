import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/theme/mytheme.dart';

class GPAScreen extends StatefulWidget {
  const GPAScreen({super.key});

  @override
  GPAScreenState createState() => GPAScreenState();
}

class GPAScreenState extends State<GPAScreen> {
  final _formKey = GlobalKey<FormState>();

  int _numCourses = 1;
  final List<double> _grades = [0.0];
  final List<int> _credits = [0];

  final Map<String, double> _gradePointMap = {
    'A': 4.0,
    'B+': 3.5,
    'B': 3.0,
    'C+': 2.5,
    'C': 2.0,
    'D+': 1.5,
    'D': 1.0,
    'F': 0.0,
  };

  final List<int> courseCredit = [1, 2, 3, 4, 5, 6];

  void _addCourse() {
    setState(() {
      _numCourses++;
      _grades.add(0.0);
      _credits.add(0);
    });
  }

  void _removeCourse() {
    setState(() {
      if (_numCourses > 1) {
        _numCourses--;
        _grades.removeLast();
        _credits.removeLast();
      }
    });
  }

  double _calculateGPA() {
    double totalGradePoints = 0;
    int totalCredits = 0;

    for (int i = 0; i < _numCourses; i++) {
      totalGradePoints += _grades[i] * _credits[i];
      totalCredits += _credits[i];
    }

    if (totalCredits == 0) {
      return 0.0;
    }

    return totalGradePoints / totalCredits;
  }

  @override
  void dispose() {
    _grades.clear();
    _credits.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Calculator'),
        centerTitle: true,
        // actions: [
        //   TextButton(
        //       child: const Text(
        //         'CGPA',
        //         style: TextStyle(),
        //       ),
        //       onPressed: () => Navigator.pushNamed(context, "/cgpa-screen")),
        // ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < _numCourses; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 8.0),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField<double>(
                              decoration: InputDecoration(
                                labelText: 'Course Grade',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.themeData(false, context)
                                          .focusColor,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.5, style: BorderStyle.solid),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.5, style: BorderStyle.solid),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              items: _gradePointMap.entries
                                  .map(
                                    (entry) => DropdownMenuItem(
                                      key: Key("grade${entry.key}"),
                                      value: entry.value,
                                      child: Text(entry.key),
                                    ),
                                  )
                                  .toList(),
                              // value: 1,
                              validator: (value) {
                                if (value == null || value == 0) {
                                  return 'Please select a grade';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _grades[i] = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: ' Credits Hours',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppTheme.themeData(false, context)
                                          .focusColor,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.5, style: BorderStyle.solid),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0.5, style: BorderStyle.solid),
                                ),
                                errorBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                      style: BorderStyle.solid),
                                ),
                              ),
                              items: courseCredit
                                  .map(
                                    (credit) => DropdownMenuItem(
                                      key: Key("credit${credit.toString()}"),
                                      value: credit,
                                      child: Text(credit.toString()),
                                    ),
                                  )
                                  .toList(),
                              // value: 1,
                              validator: (value) {
                                if (value == null || value == 0) {
                                  return 'Please select a number of credits';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _credits[i] = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: _addCourse,
                        label: const Text("Add"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: cPri,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: cPri,
                            ),
                          ),
                          fixedSize: const Size(140, 50),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.remove),
                        onPressed: _removeCourse,
                        label: const Text("Remove"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: cPri,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: cPri,
                            ),
                          ),
                          fixedSize: const Size(140, 50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        double gpa = _calculateGPA();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 200,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Your GPA is $gpa",
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                  const SizedBox(height: 50),
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
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(160, 50),
                      maximumSize: const Size(160, 50),
                      elevation: 0,
                      backgroundColor:
                          AppTheme.themeData(false, context).focusColor,
                      foregroundColor:
                          AppTheme.themeData(false, context).primaryColor,
                    ),
                    child: const Text('Calculate GPA'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
