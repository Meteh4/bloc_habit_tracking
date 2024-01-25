import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:getwidget/getwidget.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:habittin/Widgets/AuthEmail.dart';
import 'package:habittin/utils/ColorAdjuster.dart';
import 'package:habittin/utils/HabitUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:line_icons/line_icons.dart';

class EditHabitScreen extends StatefulWidget {
  final int habitIndex;

  EditHabitScreen({required this.habitIndex});

  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TimeOfDay _selectedTime;
  late int _currentCounter;
  late int _targetCounter;
  late bool _day1;
  late bool _day2;
  late bool _day3;
  late bool _day4;
  late bool _day5;
  late bool _day6;
  late bool _day7;
  late bool _isHabitCountable;
  late Color _color;
  late bool _completed;
  late int _streak;

  @override
  void initState() {
    super.initState();
    Habit habit = Hive.box<Habit>('habits').getAt(widget.habitIndex)!;
    _isHabitCountable = false;
    _nameController = TextEditingController(text: habit.name);
    _descriptionController = TextEditingController(text: habit.description);
    _selectedTime = habit.time;
    _currentCounter = habit.currentCounter;
    _targetCounter = habit.targetCounter;
    _day1 = habit.day1;
    _day2 = habit.day2;
    _day3 = habit.day3;
    _day4 = habit.day4;
    _day5 = habit.day5;
    _day6 = habit.day6;
    _day7 = habit.day7;
    _color = habit.color;
    _completed = habit.completed;
    _streak = habit.streak;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:!isDarkColor(_color) ? _color : getAdjustedColor(_color),
      appBar: AppBar(
        backgroundColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
        title: Text('Edit Habit',
        style: TextStyle(
          color: !isDarkColor(_color) ? _color : getAdjustedColor(_color),
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                        borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                        borderRadius: BorderRadius.circular(20.10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                        borderRadius: BorderRadius.circular(20.10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                        borderRadius: BorderRadius.circular(20.10),
                      ),
                      labelText: 'HabitName',
                      hintStyle: TextStyle(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                      labelStyle: TextStyle(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
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
                        color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                      )
                    ),
                    child: ListTile(
                      title: Text('Select Time',
                      style: TextStyle(
                        color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                      ),
                      ),
                      subtitle: Text(_selectedTime.format(context),
                      style: TextStyle(
                        color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                      color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                              color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                            ),),
                            Switch(
                              inactiveTrackColor: getAdjustedColor(_color),
                              inactiveThumbColor: _color,
                              activeColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                                    borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                    borderRadius: BorderRadius.circular(20.10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                    borderRadius: BorderRadius.circular(20.10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                    borderRadius: BorderRadius.circular(20.10),
                                  ),
                                  labelText: 'Target Counter',
                                  hintStyle: TextStyle(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                  labelStyle: TextStyle(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                                      borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                      borderRadius: BorderRadius.circular(20.10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                      borderRadius: BorderRadius.circular(20.10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:  BorderSide(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                                      borderRadius: BorderRadius.circular(20.10),
                                    ),
                                    labelText: 'Target Counter',
                                    labelStyle: TextStyle(color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                              color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                              color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                              color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                              color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                            ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                               color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                             ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                            color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                          ),),
                        ],
                      ),
                      Column(
                        children: [
                          GFCheckbox(
                            activeBgColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
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
                            color: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                          ),
                           ),
                        ],
                      ),
                    ],
                  ),
                ),

                FloatingActionButton.extended(
                  backgroundColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                  onPressed: () {
                    _showColorPicker();
                  },
                  icon: Icon(LineIcons.palette,
                    color: !isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                  label: Text('Pick Color',
                  style: TextStyle(
                    color: !isDarkColor(_color) ? _color : getAdjustedColor(_color),
                  ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton.extended(
                        backgroundColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                        onPressed: () {
                          _deleteHabit();
                          Navigator.pop(context, true);
                          sortHabitsByTime(Hive.box<Habit>('habits'));
                        },
                        icon: Icon(LineIcons.trash,
                          color: !isDarkColor(_color) ? _color : getAdjustedColor(_color),),
                        label: Text('Delete Habit',
                          style: TextStyle(
                            color: !isDarkColor(_color) ? _color : getAdjustedColor(_color),
                          ),
                        ),
                      ),
                      FloatingActionButton.extended(
                        backgroundColor: isDarkColor(_color) ? _color : getAdjustedColor(_color),
                        onPressed: () {
                          _updateHabit();
                        },
                        label: Text('Update Habit', style: TextStyle(color: !isDarkColor(_color) ? _color : getAdjustedColor(_color))),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor:_color,
              onColorChanged: (Color color) {
                setState(() {
                  _color = color;
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

  void _deleteHabit() {
    Hive.box<Habit>('habits').deleteAt(widget.habitIndex);

  }

  void _updateHabit() {
    Habit updatedHabit = Habit()
    ..streak = _streak
    ..completed = _completed
    ..color = _color
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
      ..day7 = _day7;

    Hive.box<Habit>('habits').putAt(widget.habitIndex, updatedHabit);
    Navigator.pop(context, true);
  }
}
