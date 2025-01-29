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
  bool isTemplateMode = false;
  Map<String, Map<String, String>> templateData = {};
  Map<String, Map<String, String>> regularData = {};

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
        title: Text(isTemplateMode ? 'Edit Template' : 'Class Schedule'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isTemplateMode ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                isTemplateMode = !isTemplateMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                label:
                    Text('Day', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...timeSlots
                  .map((slot) => DataColumn(
                        label: Text(slot,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTimeSlot,
        child: const Icon(Icons.add),
      ),
    );
  }

  DataCell _buildCell(String day, String slot) {
    String? templateValue = templateData[day]?[slot];
    String? regularValue = regularData[day]?[slot];

    if (isTemplateMode) {
      return DataCell(
        TextField(
          decoration: const InputDecoration(border: InputBorder.none),
          controller: TextEditingController(text: templateValue),
          onChanged: (value) {
            setState(() {
              templateData[day] ??= {};
              templateData[day]![slot] = value;
            });
          },
        ),
      );
    } else {
      if (templateValue != null) {
        return DataCell(Text(templateValue));
      } else {
        return DataCell(
          TextField(
            decoration: const InputDecoration(border: InputBorder.none),
            controller: TextEditingController(text: regularValue),
            onChanged: (value) {
              setState(() {
                regularData[day] ??= {};
                regularData[day]![slot] = value;
              });
            },
          ),
        );
      }
    }
  }

  DataRow _buildDataRow(String day) {
    return DataRow(
      cells: [
        DataCell(
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold))),
        ...timeSlots.map((slot) => _buildCell(day, slot)).toList(),
      ],
    );
  }
}
