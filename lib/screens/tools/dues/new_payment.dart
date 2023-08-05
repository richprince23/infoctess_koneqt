import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/components/input_control1.dart';
import 'package:infoctess_koneqt/components/select_control1.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:infoctess_koneqt/env.dart';
import 'package:resize/resize.dart';

class NewPayment extends StatefulWidget {
  const NewPayment({super.key});

  @override
  State<NewPayment> createState() => _NewPaymentState();
}

class _NewPaymentState extends State<NewPayment> {
  final List<String> levels = [
    'Level 100',
    'Level 200',
    'Level 300',
    'Level 400',
  ];

  final List<String> classgroup = [
    'Group 1',
    'Group 2',
    'Group 3',
    'Group 4',
    'Group 5',
    'Group 6',
    'Group 7',
    'Group 8',
    'Group 9',
    'Group 10',
  ];

  String selectedLevel = '';
  String selectedClassGroup = '';
  final indexNumberController = TextEditingController();
  final amountController = TextEditingController();
  late TextEditingController nameController;

  @override
  initState() {
    super.initState();
    selectedLevel = levels[0];
    selectedClassGroup = classgroup[0];
    nameController = TextEditingController(text: curUser!.fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Payment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 100.vh - kToolbarHeight - 20,
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              Text(
                'Enter the details of the payment',
                style: TextStyle(fontSize: 18.sp),
              ),
              const SizedBox(
                height: 20,
              ),
              InputControl(
                hintText: 'Name',
                controller: nameController,
                readOnly: true,
              ),
              InputControl(
                hintText: 'Amount',
                type: TextInputType.number,
                controller: amountController,
              ),
              InputControl(
                hintText: 'Index Number',
                controller: indexNumberController,
              ),
              SelectControl(
                onChanged: (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
                items: levels
                    .map((e) => DropdownMenuItem(value: (e), child: Text(e)))
                    .toList(),
                hintText: 'Select Level',
              ),
              SelectControl(
                onChanged: (value) {
                  setState(() {
                    selectedClassGroup = value!;
                  });
                },
                items: classgroup
                    .map((e) => DropdownMenuItem(value: (e), child: Text(e)))
                    .toList(),
                hintText: 'Select Group',
              ),
              const Spacer(
                  // height: 20,
                  ),
              SizedBox(
                width: 100.vw,
                height: 50.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPri,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text(
                    'submit',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
