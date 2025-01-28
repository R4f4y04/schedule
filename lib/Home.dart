import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> timeSlots = [
    '9:00-9:50',
    '10:00-10:30',
    '10:30-11:20',
    '11:20-12:30',
    '12:30-1:20',
    '1:20-2:30',
    '2:30-3:20',
    '3:20-4:30',
    '4:30-5:30',
    '5:30-6:30'
  ];

  void addTimeSlot() {
    setState(() {
      String lastTime = timeSlots.last.split('-')[1];
      String newStart = lastTime;
      String newEnd =
          "${int.parse(lastTime.split(':')[0]) + 1}:${lastTime.split(':')[1]}";
      timeSlots.add('$newStart-$newEnd');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: TimeTable(timeSlots: timeSlots),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTimeSlot,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TimeTable extends StatelessWidget {
  final List<String> timeSlots;

  const TimeTable({super.key, required this.timeSlots});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          dividerThickness: 2,
          columnSpacing: 20,
          headingRowHeight: 60,
          dataRowHeight: 60,
          columns: [
            const DataColumn(
              label: Text('Day', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            ...timeSlots
                .map((slot) => DataColumn(
                      label: Text(slot,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ))
                .toList(),
          ],
          rows: [
            _buildDataRow('Monday'),
            _buildDataRow('Tuesday'),
            _buildDataRow('Wednesday'),
            _buildDataRow('Thursday'),
            _buildDataRow('Friday'),
            _buildDataRow('Saturday'),
            _buildDataRow('Sunday'),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String day) {
    return DataRow(
      cells: [
        DataCell(
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold))),
        ...timeSlots
            .map((slot) => const DataCell(
                  SizedBox(
                    width: 100,
                    child: Text(''),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
