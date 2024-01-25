part of 'habit_bloc.dart';

abstract class HabitState {}

class HabitsLoadedState extends HabitState {
  final List<Habit> habits;

  HabitsLoadedState(this.habits);
}