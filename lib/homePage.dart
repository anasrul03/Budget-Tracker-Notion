import 'package:budget_tracker/tabBars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Expanded(
              child: TabBarAndTabViews(),
            ),
            ElevatedButton(
              onPressed: () async {
                // This is in order to get the selected date.
                final selectedDate =
                    await SimpleMonthYearPicker.showMonthYearPickerDialog(
                        context: context,
                        titleTextStyle: TextStyle(),
                        monthTextStyle: TextStyle(),
                        yearTextStyle: TextStyle(),
                        disableFuture:
                            true // This will disable future years. it is false by default.
                        );
                // Use the selected date as needed
                print('Selected date: $selectedDate');
              },
              child: const Text('show dialog'),
            )
          ],
        ),
      ),
    );
  }
}
