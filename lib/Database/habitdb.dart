// habitdb.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Habit {
  late String key;
  late String name;
  late TimeOfDay time;
  late String description;
  late int currentCounter;
  late int targetCounter;
  late bool day1;
  late bool day2;
  late bool day3;
  late bool day4;
  late bool day5;
  late bool day6;
  late bool day7;
  late bool completed;
  late DateTime currentDate;
  late bool isHidden;
  late Color color;
  late int streak;

  bool getDayValue(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return day1;
      case 'tuesday':
        return day2;
      case 'wednesday':
        return day3;
      case 'thursday':
        return day4;
      case 'friday':
        return day5;
      case 'saturday':
        return day6;
      case 'sunday':
        return day7;
      default:
        return false; // Handle other cases as needed
    }
  }

  Habit() {
    key = UniqueKey().toString();
    completed = false;
    currentCounter = 0;
    targetCounter = 0;
    day1 = false;
    day2 = false;
    day3 = false;
    day4 = false;
    day5 = false;
    day6 = false;
    day7 = false;
    currentDate = DateTime.now();
    isHidden = false;
    color = Colors.indigo;
    streak = 0;
  }
}



class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    var habit = Habit();
    habit.name = reader.read();
    habit.time = reader.read();
    habit.description = reader.read();
    habit.currentCounter = reader.read();
    habit.targetCounter = reader.read();
    habit.day1 = reader.read();
    habit.day2 = reader.read();
    habit.day3 = reader.read();
    habit.day4 = reader.read();
    habit.day5 = reader.read();
    habit.day6 = reader.read();
    habit.day7 = reader.read();
    habit.completed = reader.read();
    habit.currentDate = reader.read();
    habit.color = reader.read();
    habit.streak = reader.read();
    return habit;
  }


  @override
  void write(BinaryWriter writer, Habit habit) {
    writer.write(habit.name);
    writer.write(habit.time);
    writer.write(habit.description);
    writer.write(habit.currentCounter);
    writer.write(habit.targetCounter);
    writer.write(habit.day1);
    writer.write(habit.day2);
    writer.write(habit.day3);
    writer.write(habit.day4);
    writer.write(habit.day5);
    writer.write(habit.day6);
    writer.write(habit.day7);
    writer.write(habit.completed);
    writer.write(habit.currentDate);
    writer.write(habit.color);
    writer.write(habit.streak);
  }


  @override
  int get sortField => 1;

  @override
  int compare(Habit habit1, Habit habit2) {
    final int time1 = habit1.time.hour * 60 + habit1.time.minute;
    final int time2 = habit2.time.hour * 60 + habit2.time.minute;

    print('Habit 1: ${habit1.name}, Saat: ${habit1.time}, Dakika: $time1');
    print('Habit 2: ${habit2.name}, Saat: ${habit2.time}, Dakika: $time2');

    final result = time1.compareTo(time2);
    print('Compare Result: $result');

    return result;
  }
}



class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 1;

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readByte();
    final minute = reader.readByte();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeByte(obj.hour);
    writer.writeByte(obj.minute);
  }
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 2; // You can choose any unique number here

  @override
  Color read(BinaryReader reader) {
    final value = reader.readInt32();
    return Color(value);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt32(obj.value);
  }
}

