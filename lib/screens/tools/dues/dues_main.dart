import 'package:flutter/material.dart';
import 'package:infoctess_koneqt/constants.dart';
import 'package:resize/resize.dart';

class MyDuesScreen extends StatelessWidget {
  const MyDuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Dues"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cPri,
                  foregroundColor: Colors.white,
                  fixedSize: btnLarge(context),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/new-payment");
                },
                child: Text(
                  "New Payment",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                builder: ((context, snapshot) {
                  return ListView.builder(
                    itemCount: 15,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        title: Text("Payment $index"),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
