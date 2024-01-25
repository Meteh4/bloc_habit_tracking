import 'package:flutter/material.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class DataInputScreen extends StatefulWidget {
  @override
  _DataInputScreenState createState() => _DataInputScreenState();
}

class _DataInputScreenState extends State<DataInputScreen> {
  final valueController = TextEditingController();
  late Box<Habit> _habitsBox;
  late Box myBox;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _habitsBox = Hive.box<Habit>('habits');
    initBox();
  }

  Future<void> initBox() async {
    myBox = await Hive.openBox('myBox');
  }

  @override
  void dispose() {
    myBox?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Data Input'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
            trailing: const Icon(Icons.calendar_today),
          ),
          TextField(
            controller: valueController,
            decoration: const InputDecoration(
              hintText: 'Enter value',
            ),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              _onStoreDataButtonPressed();
            },
            label: const Text('Store data in Hive'),
          ),
        ],
      ),
    );
  }
  
  void _onStoreDataButtonPressed() {
    if (_habitsBox != null) {
      String date = DateFormat('yyyy-MM-dd').format(selectedDate);
      double value = calculateCompletionRatio(_habitsBox.values.toList());
      myBox.put(date, value);
      print('Stored $value at $date in Hive');

      // Güncelleme işlemleri
      for (int i = 0; i < _habitsBox.length; i++) {
        Habit habit = _habitsBox.getAt(i) as Habit;
        habit.completed = value >= 1.0; // Örnek bir kontrol
        _habitsBox.putAt(i, habit);
      }
    } else {
      print('Error: Hive box is null.');
    }
  }

  double calculateCompletionRatio(List<Habit> habits) {
    int completedCount = habits.where((habit) => habit.completed).length;
    int totalHabitsCount = habits.length;

    if (totalHabitsCount == 0) {
      return 0.0; // To avoid division by zero error
    }

    return completedCount / totalHabitsCount;
  }
}