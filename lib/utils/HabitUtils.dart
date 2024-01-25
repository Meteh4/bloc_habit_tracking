

import 'package:habittin/Database/habitdb.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

void storeData(Box<Habit> habitBox, Box myBox, DateTime selectedDate) {
  if (habitBox != null) {
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    double value = calculateCompletionRatio(habitBox.values.toList());
    myBox.put(date, value);
    print('Stored $value at $date in Hive');
  } else {
    print('Error: Hive box is null.');
  }
}

double calculateCompletionRatio(List<Habit> habits) {
  int completedCount = habits.where((habit) => habit.completed && !habit.isHidden).length;
  int totalHabitsCount = habits.where((habit) => !habit.isHidden).length;

  if (totalHabitsCount == 0) {
    return 0.0;
  }

  return completedCount / totalHabitsCount;
}


void sortHabitsByTime(Box<Habit> habitBox) {
  var sortedHabits = List<Habit>.from(habitBox.values)
    ..sort((habit1, habit2) => habit1.time.hour * 60 + habit1.time.minute - (habit2.time.hour * 60 + habit2.time.minute));

  var updatedHabitsMap = <int, Habit>{};

  for (var i = 0; i < sortedHabits.length && i < habitBox.length; i++) {
    var habit = sortedHabits[i];

    // Check if the index is within the valid range
    if (i < habitBox.length) {
      updatedHabitsMap[habitBox.keyAt(i)!] = habit;
    } else {
      // Handle the case where the index is out of range
      print('Index out of range: $i');
    }
  }

  // Update the habitBox after the iteration is complete
  habitBox.putAll(updatedHabitsMap);
}



class HabitUtils {
  static double calculateCompletionRatio(List<Habit> habits) {
    int completedCount = habits.where((habit) => habit.completed).length;
    int totalHabitsCount = habits.where((habit) => !habit.isHidden).length;

    if (totalHabitsCount == 0) {
      return 0.0; // Sıfıra bölme hatasını önlemek için
    }

    return completedCount / totalHabitsCount;
  }

  static void checkAndResetCompleted(Box<Habit> habitBox) {
    DateTime now = DateTime.now();
    DateTime lastCheckedDate = now.subtract(Duration(days: 1)); // Geçmiş bir tarih

    if (now.day != lastCheckedDate.day) {
      for (int i = 0; i < habitBox.length; i++) {
        Habit habit = habitBox.getAt(i)!;
        habit.completed = false;
        habitBox.putAt(i, habit);
      }
    }
  }
}
