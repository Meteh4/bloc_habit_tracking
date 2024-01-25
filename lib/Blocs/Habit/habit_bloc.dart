import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:habittin/utils/HabitUtils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final Box<Habit> habitBox;
  final Box myBox;
  DateTime lastCheckedDate = DateTime.now();
  DateTime lastNotificationReset = DateTime.now(); // Yeni bir değişken
  late Timer timer; // Timer variable

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Set<String> notifiedHabits = Set(); // Set to track notified habits

  HabitBloc(this.habitBox, this.myBox)
      : super(HabitsLoadedState(habitBox.values.toList())) {
    on<LoadHabitsEvent>((event, emit) async {
      sortHabitsByTime(habitBox);
      updateHabitVisibility();
      checkAndResetCompleted();
      emit(HabitsLoadedState(await _loadHabits()));
    });

    on<UpdateHabitVisibilityEvent>((event, emit) async {
      updateHabitVisibility();
      _onStoreDataButtonPressed();
      emit(HabitsLoadedState(await _loadHabits()));
    });

    on<AddHabitEvent>((event, emit) async {
      print('AddHabitEvent handler executed');
      habitBox.add(event.habit);
      updateHabitVisibility();
      _onStoreDataButtonPressed();
      emit(HabitsLoadedState(await _loadHabits()));
    });

    on<UpdateHabitEvent>((event, emit) async {
      sortHabitsByTime(habitBox);
      habitBox.putAt(event.index, event.updatedHabit);
      updateHabitVisibility();
      emit(HabitsLoadedState(await _loadHabits()));
      _onStoreDataButtonPressed();
    });

    on<DeleteHabitEvent>((event, emit) async {
      habitBox.deleteAt(event.index);
      sortHabitsByTime(habitBox);
      updateHabitVisibility();
      _onStoreDataButtonPressed();
      emit(HabitsLoadedState(await _loadHabits()));
    });

    on<StoreDataEvent>((event, emit) async {
      // Handle the StoreDataEvent if needed
    });

    on<CheckAndResetCompletedEvent>((event, emit) {
      checkAndResetCompleted();
    });

    // Start the timer when the bloc is created
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      add(CheckAndResetCompletedEvent());
      sortHabitsByTime(habitBox);
      checkAndSendNotification();
    });
  }

  Future<List<Habit>> _loadHabits() async {
    return habitBox.values.toList();
  }

  void updateHabitVisibility() {
    DateTime now = DateTime.now();
    String currentDay = getDayName(now.weekday);

    for (int i = 0; i < habitBox.length; i++) {
      Habit habit = habitBox.getAt(i)!;
      bool habitDayValue = habit.getDayValue(currentDay.toLowerCase());
      habit.isHidden = !habitDayValue;
    }
  }

  void _onStoreDataButtonPressed() {
    if (habitBox != null) {
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      double value = calculateCompletionRatio(habitBox.values.toList());
      myBox.put(date, value);
      print('Stored $value at $date in Hive');
    } else {
      print('Error: Hive box is null.');
    }
  }

  void checkAndSendNotification() {
    DateTime now = DateTime.now();
    String currentDay = getDayName(now.weekday);

    // Her gün bir kez notifiedHabits set'ini sıfırla
    if (now.day != lastNotificationReset.day) {
      notifiedHabits.clear();
      lastNotificationReset = now;
    }

    for (int i = 0; i < habitBox.length; i++) {
      Habit habit = habitBox.getAt(i)!;

      if (habit.getDayValue(currentDay.toLowerCase()) &&
          habit.time.hour == now.hour &&
          habit.time.minute == now.minute &&
          !notifiedHabits.contains(habit.name)) {
        _sendNotification(habit.name);
        notifiedHabits.add(habit.name);
      }
    }
  }

  Future<void> _sendNotification(String habitName) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'habittin',
      'Habit Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'It\'s time for $habitName!',
      platformChannelSpecifics,
      payload: 'habit_payload',
    );
  }

  void checkAndResetCompleted() {
    DateTime now = DateTime.now();
    if (now.day != lastCheckedDate.day) {
      lastCheckedDate = now;
      notifiedHabits.clear(); // Reset the set of notified habits
      for (int i = 0; i < habitBox.length; i++) {
        Habit habit = habitBox.getAt(i)!;
        updateStreak(habit);
        habit.completed = false;
        habitBox.putAt(i, habit);
      }
      add(UpdateHabitVisibilityEvent()); // Trigger an event to update visibility
    }
  }

  void updateStreak(Habit habit) {
    if (habit.completed) {
      habit.streak++;
    } else {
      habit.streak = 0;
    }
  }

  String getDayName(int dayIndex) {
    return DateFormat('EEEE').format(DateTime(2024, 1, dayIndex));
  }

  @override
  Future<void> close() {
    // Cancel the timer when the bloc is closed
    timer.cancel();
    return super.close();
  }
}
