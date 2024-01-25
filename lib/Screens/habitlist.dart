// habit_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Blocs/Habit/habit_bloc.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:habittin/Screens/Delete.dart';
import 'package:habittin/Screens/Habit.dart';
import 'package:habittin/Screens/edithabit.dart';
import 'package:habittin/Widgets/LiquidProgressIndicator.dart';
import 'package:habittin/Widgets/WeekWidget.dart';
import 'package:habittin/Widgets/sss.dart';
import 'package:habittin/utils/ColorAdjuster.dart';
import 'package:hive/hive.dart'; // Import AddHabitScreen

class HabitList extends StatefulWidget {
  const HabitList({Key? key}) : super(key: key);

  @override
  _HabitListState createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  late HabitBloc habitBloc;

  @override
  void initState() {
    super.initState();
    habitBloc = HabitBloc(Hive.box<Habit>('habits'), Hive.box('myBox'));
    habitBloc.add(LoadHabitsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => habitBloc,
      child: Scaffold(
        body: BlocBuilder<HabitBloc, HabitState>(
          builder: (context, state) {
            if (state is HabitsLoadedState) {
              return Column(
                children: [
                  WeeksPageView(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(13),
                                 border: Border.all(width: 2, color: Colors.white),
                               ),
                               child: Column(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Align(
                                       alignment: Alignment.centerLeft ,
                                       child: Container(
                                         child: const Text('Completed Total Habits :',
                                         style: TextStyle(
                                           color: Colors.indigo
                                         ),
                                         textAlign: TextAlign.left,
                                         ),
                                       ),
                                     ),
                                   ),
                                   Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(12),
                                     ),
                                     height: 75,
                                     child: LiquidIndicator(
                                       value: calculateCompletionRatio(state.habits),
                                       centertext: Text(
                                         '${(calculateCompletionRatio(state.habits) * 100).toStringAsFixed(0)}%',
                                         style: const TextStyle(
                                           fontSize: 24,
                                           color: Colors.white,
                                         ),
                                       ),

                            ),
                                   ),
                                 ],
                               ),
                             ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.habits.length,
                      itemBuilder: (context, index) {
                        Habit habit = state.habits[index];
                        if (!habit.isHidden) {
                          return Padding(
                            padding: EdgeInsets.all(12),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditHabitScreen(habitIndex: index),
                                  ),
                                ).then((result) {
                                  if (result != null && result == true) {
                                    // Refresh the habit list or trigger the necessary action
                                    habitBloc.add(LoadHabitsEvent());
                                  }
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: habit.color,
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  border: Border.all(
                                    width: 2,
                                    color: isDarkColor(habit.color) ? habit.color : getAdjustedColor(habit.color),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Container(
                                        height: 80,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Container(
                                          height: 85,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Align(
                                                  alignment: const AlignmentDirectional(-1, 0),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional.fromSTEB(
                                                        10, 0, 0, 0),
                                                    child: Text(
                                                      habit.name,
                                                      style: TextStyle(
                                                        color: isDarkColor(habit.color) ? habit.color : getAdjustedColor(habit.color),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Visibility(
                                                      visible: habit.currentCounter > 0,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius.circular(14),
                                                              border: Border.all(
                                                                color: Colors.grey,
                                                              )),
                                                          child: ClipOval(
                                                            child: FloatingActionButton(
                                                              elevation: 0,
                                                              backgroundColor:
                                                              Colors.transparent,
                                                              onPressed: () {
                                                                setState(() {
                                                                  habit.currentCounter--;
                                                                  habit.completed = false;
                                                                  habitBloc.add(
                                                                      UpdateHabitEvent(
                                                                          index, habit));
                                                                });
                                                              },
                                                              child: const Icon(Icons.remove,
                                                                  size: 18),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: habit.targetCounter > 1 &&
                                                          habit.targetCounter !=
                                                              habit.currentCounter,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(14),
                                                            border: Border.all(
                                                              color: Colors.grey,
                                                            )),
                                                        width: 40,
                                                        height: 40,
                                                        child: FloatingActionButton(
                                                          elevation: 0,
                                                          backgroundColor:
                                                          Colors.transparent,
                                                          onPressed: () {
                                                            setState(() {
                                                              if (habit.currentCounter <
                                                                  habit.targetCounter) {
                                                                habit.currentCounter++;
                                                                if (habit.currentCounter ==
                                                                    habit.targetCounter) {
                                                                  habit.completed = true;
                                                                }
                                                                habitBloc.add(
                                                                    UpdateHabitEvent(
                                                                        index, habit));
                                                              }
                                                            });
                                                          },
                                                          child: const Icon(Icons.add, size: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                                      0, 0, 10, 0),
                                                  child: Theme(
                                                    data: ThemeData(
                                                      checkboxTheme: CheckboxThemeData(
                                                        visualDensity: VisualDensity.compact,
                                                        materialTapTargetSize:
                                                        MaterialTapTargetSize.shrinkWrap,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Checkbox(
                                                      activeColor: habit.color,
                                                      checkColor:
                                                      getAdjustedColor(habit.color),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4)),
                                                      value: habit.completed,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          habit.completed = value!;
                                                          if (habit.completed) {
                                                            habit.currentCounter =
                                                                habit.targetCounter;
                                                          } else {
                                                            habit.currentCounter = 0;
                                                          }
                                                          habitBloc.add(
                                                              UpdateHabitEvent(index, habit));
                                                          _onStoreDataButtonPressed();
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 3),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Time',
                                                style: TextStyle(
                                                  color: getAdjustedColor(habit.color),
                                                  // Check brightness of habit.color and choose text color accordingly
                                                ),
                                              ),
                                              Text(
                                                '${habit.time.hourOfPeriod}.${habit.time.minute} ${habit.time.period.toString().split('.').last.toUpperCase()}',
                                                style: TextStyle(
                                                  color: getAdjustedColor(habit.color),
                                                  // Use the same brightness check for the text color
                                                ),
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: habit.targetCounter > 1,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  habit.description,
                                                  style: TextStyle(
                                                    color: getAdjustedColor(habit.color),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${habit.currentCounter}',
                                                      style: TextStyle(
                                                        color: getAdjustedColor(habit.color),
                                                      ),
                                                    ),
                                                    Text(
                                                      ' of ',
                                                      style: TextStyle(
                                                        color: getAdjustedColor(habit.color),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${habit.targetCounter}',
                                                      style: TextStyle(
                                                        color: getAdjustedColor(habit.color),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Streak',
                                                style: TextStyle(
                                                  color: getAdjustedColor(habit.color),
                                                ),
                                              ),
                                              Text(
                                                '${habit.streak}',
                                                style: TextStyle(
                                                  color: getAdjustedColor(habit.color),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddHabitScreen(),
              ),
            ).then((result) {
              if (result != null && result == true) {
                habitBloc.add(LoadHabitsEvent());
                _onStoreDataButtonPressed();
              }
            });
          },
          backgroundColor: Colors.indigo,
          label: Text('Add Habit',
          style: TextStyle(
            color: Colors.indigo[100],
          ),
          ),
          icon: Icon(Icons.add,
          color: Colors.indigo[100],
          ),
        ),
      ),
    );
  }

  void _onStoreDataButtonPressed() {
    habitBloc.add(UpdateHabitVisibilityEvent());
  }




  double calculateCompletionRatio(List<Habit> habits) {
    int completedCount =
        habits.where((habit) => habit.completed && !habit.isHidden).length;
    int totalHabitsCount = habits.where((habit) => !habit.isHidden).length;

    if (totalHabitsCount == 0) {
      return 0.0;
    }
    return completedCount / totalHabitsCount;
  }

  int completedCount(List<Habit> habits) {
    int completedCount =
        habits.where((habit) => habit.completed && !habit.isHidden).length;

    return completedCount;
  }

  int totalhabitsCount(List<Habit> habits) {
    int totalHabitsCount = habits.where((habit) => !habit.isHidden).length;

    return totalHabitsCount;
  }
}
