import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habittin/Database/habitdb.dart';
import 'package:habittin/Screens/Habit.dart';
import 'package:habittin/app.dart';
import 'package:habittin/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user_repository/user_repository.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  var notificationStatus = await Permission.notification.status;

  if (notificationStatus.isDenied || notificationStatus.isDenied) {
    await Permission.notification.request();
  }
  var ignoreBattery = await Permission.ignoreBatteryOptimizations;
  if (await ignoreBattery.isRestricted) {
    await Permission.ignoreBatteryOptimizations.request();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  await initNotifications();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox<Habit>('habits');
  await Hive.openBox('myBox');
  runApp(MyApp(FirebaseUserRepo()));
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}


