// ignore_for_file: file_names, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Timing extends StatelessWidget {
  Timing({
    super.key,
  });

  final List<WorkTiming> workTimings = [
    WorkTiming(day: 'Monday', startTime: '9:00 AM', endTime: '5:00 PM'),
    WorkTiming(day: 'Tuesday', startTime: '9:00 AM', endTime: '5:00 PM'),
    WorkTiming(day: 'Wednesday', startTime: '9:00 AM', endTime: '5:00 PM'),
    WorkTiming(day: 'Thursday', startTime: '9:00 AM', endTime: '5:00 PM'),
    WorkTiming(day: 'Friday', startTime: '9:00 AM', endTime: '1:00 PM'),
    WorkTiming(day: 'Saturday', startTime: '9:00 AM', endTime: '5:00 PM'),

    // Add more work timings here
  ];

  Future<void> _exportToPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                text: 'Work Timing Schedule',
              ),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Day', 'Start Time', 'End Time'],
                  for (final timing in workTimings)
                    [timing.day, timing.startTime, timing.endTime],
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/work_timing_schedule.pdf');
    await file.writeAsBytes(pdf.save() as List<int>);

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Work Timing",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff392850),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Your Work Timing Schedule",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DataTable(
              columns: [
                DataColumn(label: Text('Day')),
                DataColumn(label: Text('Start Time')),
                DataColumn(label: Text('End Time')),
              ],
              rows: workTimings.map((timing) {
                return DataRow(cells: [
                  DataCell(Text(timing.day)),
                  DataCell(Text(timing.startTime)),
                  DataCell(Text(timing.endTime)),
                ]);
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _exportToPDF,
              child: Text('Export to PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkTiming {
  final String day;
  final String startTime;
  final String endTime;

  WorkTiming({
    required this.day,
    required this.startTime,
    required this.endTime,
  });
}
