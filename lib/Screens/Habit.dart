import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:habittin/utils/ColorAdjuster.dart';
import 'package:habittin/utils/HabitUtils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:line_icons/line_icons.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late TimeOfDay _selectedTime;
  int _currentCounter = 0;
  int _targetCounter = 0;
  bool _day1 = true;
  bool _day2 = true;
  bool _day3 = true;
  bool _day4 = true;
  bool _day5 = true;
  bool _day6 = true;
  bool _day7 = true;
  bool _completed = false;
  late Color _selectedColor;
  late bool _isHabitCountable;
  late Box<Habit> _habitsBox;
  late Box myBox;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedTime = TimeOfDay.now();
    _habitsBox = Hive.box<Habit>('habits');
    _isHabitCountable = false;
    _selectedColor = Colors.indigo;
    initBox();
  }

  Future<void> initBox() async {
    myBox = await Hive.openBox('myBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:!isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
      appBar: AppBar(
        backgroundColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
        title: Text('Add Habit',
        style: TextStyle(
          color: !isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
        ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter habit name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                        borderRadius: BorderRadius.circular(20.10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                        borderRadius: BorderRadius.circular(20.10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                        borderRadius: BorderRadius.circular(20.10),
                      ),
                      labelText: 'HabitName',
                      hintStyle: TextStyle(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                      labelStyle: TextStyle(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                    ),
                    obscureText: false,
                    keyboardType: TextInputType.text,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                        )
                    ),
                    child: ListTile(
                      title: Text('Select Time',
                        style: TextStyle(
                          color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                        ),
                      ),
                      subtitle: Text(_selectedTime.format(context),
                        style: TextStyle(
                          color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                        ),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                      )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Is your Habit Countable?',
                              style: TextStyle(
                                color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                              ),),
                            Switch(
                              inactiveTrackColor: getAdjustedColor(_selectedColor),
                              inactiveThumbColor: _selectedColor,
                              activeColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                              onChanged: (value) {
                                setState(() {
                                  _isHabitCountable = value ?? false;
                                });
                              },
                              value: _isHabitCountable,),
                          ],
                        ),
                        if (_isHabitCountable)
                          Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                    borderRadius: BorderRadius.circular(20.10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                    borderRadius: BorderRadius.circular(20.10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                    borderRadius: BorderRadius.circular(20.10),
                                  ),
                                  labelText: 'Counter Name',
                                  hintStyle: TextStyle(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                  labelStyle: TextStyle(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                                  ),
                                ),
                                controller: _descriptionController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a counter name';
                                  }
                                  return null;
                                },
                                obscureText: false,
                                keyboardType: TextInputType.text,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                      borderRadius: BorderRadius.circular(20.10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                      borderRadius: BorderRadius.circular(20.10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:  BorderSide(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                                      borderRadius: BorderRadius.circular(20.10),
                                    ),
                                    labelText: 'Target Counter',
                                    labelStyle: TextStyle(color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                                    ),
                                  ),
                                  initialValue: _targetCounter.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      _targetCounter = int.tryParse(value) ?? 0;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day1,
                            onChanged: (value) {
                              setState(() {
                                _day1 = value ?? false;
                              });
                            },
                          ),
                          Text('Mon',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day2,
                            onChanged: (value) {
                              setState(() {
                                _day2 = value ?? false;
                              });
                            },
                          ),
                          Text('Tue',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day3,
                            onChanged: (value) {
                              setState(() {
                                _day3 = value ?? false;
                              });
                            },
                          ),
                          Text('Wed',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day4,
                            onChanged: (value) {
                              setState(() {
                                _day4 = value ?? false;
                              });
                            },
                          ),
                          Text('Thu',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day5,
                            onChanged: (value) {
                              setState(() {
                                _day5 = value ?? false;
                              });
                            },
                          ),
                          Text('Fri',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day6,
                            onChanged: (value) {
                              setState(() {
                                _day6 = value ?? false;
                              });
                            },
                          ),
                          Text('Sat',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            type: GFCheckboxType.circle,
                            value: _day7,
                            onChanged: (value) {
                              setState(() {
                                _day7 = value ?? false;
                              });
                            },
                          ),
                          Text('Sun',
                            style: TextStyle(
                              color: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: FloatingActionButton.extended(
                    backgroundColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                    onPressed: () {
                      _showColorPicker();
                    },
                    icon: Icon(LineIcons.palette,
                      color: !isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                    label: Text('Pick Color',
                      style: TextStyle(
                        color: !isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: FloatingActionButton.extended(
                    backgroundColor: isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                    icon: Icon(LineIcons.plus,
                      color: !isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),),
                    label: Text('Add Habit',
                      style: TextStyle(
                        color: !isDarkColor(_selectedColor) ? _selectedColor : getAdjustedColor(_selectedColor),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Habit newHabit = Habit()
                          ..name = _nameController.text
                          ..description = _descriptionController.text
                          ..time = _selectedTime
                          ..currentCounter = _currentCounter
                          ..targetCounter = _targetCounter
                          ..day1 = _day1
                          ..day2 = _day2
                          ..day3 = _day3
                          ..day4 = _day4
                          ..day5 = _day5
                          ..day6 = _day6
                          ..day7 = _day7
                          ..completed = _completed
                          ..color = _selectedColor; // Set the selected color

                        Hive.box<Habit>('habits').add(newHabit);
                        _onStoreDataButtonPressed();
                        sortHabitsByTime(_habitsBox);
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStoreDataButtonPressed() {
    if (_habitsBox != null) {
      String date = DateFormat('yyyy-MM-dd').format(selectedDate);
      double value = calculateCompletionRatio(_habitsBox.values.toList());
      myBox.put(date, value);
      print('Stored $value at $date in Hive');
    } else {
      print('Error: Hive box is null.');
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              enableAlpha: false,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double calculateCompletionRatio(List<Habit> habits) {
    int completedCount = habits.where((habit) => habit.completed && !habit.isHidden).length;
    int totalHabitsCount = habits.where((habit) => !habit.isHidden).length;

    if (totalHabitsCount == 0) {
      return 0.0;
    }

    return completedCount / totalHabitsCount;
  }
}
