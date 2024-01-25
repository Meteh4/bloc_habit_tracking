import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class WeeksPageView extends StatefulWidget {
  const WeeksPageView({super.key});

  @override
  _WeeksPageViewState createState() => _WeeksPageViewState();
}

class _WeeksPageViewState extends State<WeeksPageView> {
  late PageController _pageController;
  late DateTime _currentWeekStart;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    _pageController = PageController(initialPage: 100000);
    _pageController.addListener(_updateCurrentWeekStart);
  }

  @override
  void dispose() {
    _pageController.removeListener(_updateCurrentWeekStart);
    super.dispose();
  }

  void _updateCurrentWeekStart() {
    final pageIndex = _pageController.page?.round() ?? 100000;
    _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1 + 7 * (100000 - pageIndex)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              DateFormat('MMMM y').format(_currentWeekStart),
              style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                final weekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1 + 7 * (100000 - index)));

                // Check if the box is open
                if (Hive.isBoxOpen('myBox')) {
                  final box = Hive.box('myBox');

                  // Proceed only if the box is not null
                  if (box != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _getWeekDays(startOfWeek: weekStart, box: box),
                    );
                  } else {
                    print('Error: Hive box is null.');
                    return Container(); // Return an empty container or handle the error accordingly
                  }
                } else {
                  print('Error: Hive box is not open.');
                  return Container(); // Return an empty container or handle the error accordingly
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getWeekDays({required DateTime startOfWeek, required Box box}) {
    final now = DateTime.now();
    final List<Widget> weekDays = [];

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final isToday = now.day == day.day && now.month == day.month && now.year == day.year;

      final hiveKey = DateFormat('yyyy-MM-dd').format(day);
      double? hiveValue = box.get(hiveKey);
      if (hiveValue != null) {
        hiveValue = hiveValue.clamp(0.0, 1.0);
      }

      weekDays.add(
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: isToday ? Colors.indigo[900] as Color : Colors.indigo, width: 2),
              color: hiveValue != null ? Color.lerp(Colors.white, Colors.indigo, hiveValue) : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x33000000),
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: SizedBox(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    DateFormat('EEE').format(day),
                    style: TextStyle(
                      color:Colors.indigo[900],
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    DateFormat('d').format(day),
                    style: TextStyle(
                      color:Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return weekDays;
  }
}