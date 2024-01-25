// habit_event.dart
part of 'habit_bloc.dart';

abstract class HabitEvent {}

class LoadHabitsEvent extends HabitEvent {}

class UpdateHabitVisibilityEvent extends HabitEvent {}

class AddHabitEvent extends HabitEvent {
  final Habit habit;

  AddHabitEvent(this.habit);
}

class UpdateHabitEvent extends HabitEvent {
  final int index;
  final Habit updatedHabit;

  UpdateHabitEvent(this.index, this.updatedHabit);
}

class DeleteHabitEvent extends HabitEvent {
  final int index;

  DeleteHabitEvent(this.index);
}

class StoreDataEvent extends HabitEvent {}

class CheckAndResetCompletedEvent extends HabitEvent {}
