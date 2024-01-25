import 'package:flutter/material.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:hive/hive.dart';

class DeleteHabitScreen extends StatelessWidget {
  final int habitIndex;

  const DeleteHabitScreen({Key? key, required this.habitIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Habit'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to delete this habit?'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Delete habit from list or Hive box
                deleteHabit(habitIndex);

                Navigator.pop(context); // Geri dön
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void deleteHabit(int index) async {
    List<Habit> habits = await getHabitsFromList();

    if (index >= 0 && index < habits.length) {
      habits.removeAt(index);
      saveHabitsToList(habits);
    } else {
      print('Invalid index: $index');
    }
  }

  Future<List<Habit>> getHabitsFromList() async {
    // Implement your logic to get the list of habits from a storage or source
    // For example, you can use Hive to get habits from a Hive box
    // This is just a placeholder, replace it with your actual implementation
    List<Habit> habits = [];
    // Example: Hive.box<Habit>('habits').values.toList();
    return habits;
  }

  void saveHabitsToList(List<Habit> habits) {
    // Implement your logic to save the updated list of habits
    // For example, you can use Hive to save habits to a Hive box
    // This is just a placeholder, replace it with your actual implementation
    // Example: Hive.box<Habit>('habits').clear().addAll(habits);
  }
}
