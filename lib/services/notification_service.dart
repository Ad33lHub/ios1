import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  NotificationService._init();

  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    final location = tz.local;
    tz.setLocalLocation(location);

    print('🌍 Timezone initialized: $location');

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
    _isInitialized = true;
    print('✅ NotificationService initialized');
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Request notification permission
      final notifEnabled = await androidPlugin.areNotificationsEnabled();
      print('📬 Notifications enabled: $notifEnabled');

      if (notifEnabled == false) {
        final granted = await androidPlugin.requestNotificationsPermission();
        print('📬 Notification permission granted: $granted');
      }

      // Request exact alarm permission for Android 12+
      try {
        final canSchedule = await androidPlugin.canScheduleExactNotifications();
        print('⏰ Can schedule exact alarms: $canSchedule');

        if (canSchedule == false) {
          final granted = await androidPlugin.requestExactAlarmsPermission();
          print('⏰ Exact alarm permission granted: $granted');
        }
      } catch (e) {
        print('⚠️ Exact alarm permission check failed: $e');
      }
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped: ${response.id}');
  }

  // Create notification details with MAXIMUM visibility
  AndroidNotificationDetails _createAndroidDetails({
    required String channelId,
    required String channelName,
    required String channelDescription,
    required Importance importance,
    required Priority priority,
    Color? ledColor,
    bool isUrgent = false,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      icon: '@mipmap/ic_launcher',

      // SOUND & VIBRATION
      enableVibration: true,
      playSound: true,

      // VISIBILITY - These make it show on lock screen and as heads-up
      visibility: NotificationVisibility.public,
      category: isUrgent
          ? AndroidNotificationCategory.alarm
          : AndroidNotificationCategory.reminder,

      // HEADS-UP NOTIFICATION (pop-up on screen)
      fullScreenIntent: true,

      // LOCK SCREEN
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,

      // PERSISTENT
      ongoing: false,
      autoCancel: true,

      // LED
      enableLights: true,
      ledColor: ledColor ?? Colors.blue,
      ledOnMs: 1000,
      ledOffMs: 500,

      // BADGE
      channelShowBadge: true,
      number: 1,

      // STYLE - Makes notification expandable
      styleInformation: BigTextStyleInformation(
        '',
        htmlFormatBigText: true,
        contentTitle: '',
        htmlFormatContentTitle: true,
        summaryText: 'Tap to open',
        htmlFormatSummaryText: true,
      ),

      // TICKER - Shows on status bar
      ticker: 'Task Reminder',
    );
  }

  // TEST FUNCTION - Call this first to verify notifications work
  Future<void> testImmediateNotification() async {
    await _ensureInitialized();

    print('🔔 Testing immediate notification...');

    final androidDetails = _createAndroidDetails(
      channelId: 'test_channel',
      channelName: 'Test Notifications',
      channelDescription: 'Testing notification system',
      importance: Importance.max,
      priority: Priority.max,
      ledColor: Colors.green,
      isUrgent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      'Test Notification ✅',
      'If you see this as pop-up, everything works! Lock your phone and check lock screen too.',
      notificationDetails,
    );

    print('✅ Immediate notification sent with ID: 999');
  }

  // TEST FUNCTION - Test scheduled notification (30 seconds)
  Future<void> test30SecondNotification() async {
    await _ensureInitialized();

    print('⏰ Scheduling notification for 30 seconds from now...');

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(seconds: 30));

    print('📅 Current time: $now');
    print('📅 Scheduled time: $scheduledDate');

    final androidDetails = _createAndroidDetails(
      channelId: 'test_scheduled_channel',
      channelName: 'Test Scheduled Notifications',
      channelDescription: 'Testing scheduled notifications',
      importance: Importance.max,
      priority: Priority.max,
      ledColor: Colors.orange,
      isUrgent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      888,
      '30 Second Test ⏰',
      'This should appear as pop-up and on lock screen! Scheduled 30 seconds ago.',
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('✅ 30-second notification scheduled with ID: 888');
    await listPendingNotifications();
  }

  // DEBUG FUNCTION - List all pending notifications
  Future<void> listPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('📋 Pending notifications: ${pending.length}');

    for (final notification in pending) {
      print('  ID: ${notification.id} | Title: ${notification.title}');
    }

    if (pending.isEmpty) {
      print('⚠️ WARNING: No pending notifications found!');
    }
  }

  Future<void> _scheduleOneMinuteReminder(
    Task task,
    DateTime dueDateTime,
    int notificationId,
  ) async {
    final now = DateTime.now();
    if (dueDateTime.isBefore(now)) {
      print('⚠️ Due time is in the past, skipping 1-min reminder');
      return;
    }

    final reminderTime = dueDateTime.subtract(const Duration(minutes: 1));
    if (reminderTime.isBefore(now)) {
      print('⚠️ 1-min reminder time is in the past, skipping');
      return;
    }

    print('⏰ Scheduling 1-min reminder for: $reminderTime');

    final androidDetails = _createAndroidDetails(
      channelId: 'task_urgent_reminder_channel',
      channelName: 'Urgent Task Reminders',
      channelDescription: 'Critical reminders for tasks due in 1 minute',
      importance: Importance.max,
      priority: Priority.max,
      ledColor: Colors.red,
      isUrgent: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.critical,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      notificationId + 2000,
      '🚨 URGENT: 1 Minute Left!',
      '${task.title} - Complete now!',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('✅ 1-min reminder scheduled with ID: ${notificationId + 2000}');
  }

  Future<void> _scheduleFiveMinuteReminder(
    Task task,
    DateTime dueDateTime,
    int notificationId,
  ) async {
    final now = DateTime.now();
    if (dueDateTime.isBefore(now)) {
      print('⚠️ Due time is in the past, skipping 5-min reminder');
      return;
    }

    final reminderTime = dueDateTime.subtract(const Duration(minutes: 5));
    if (reminderTime.isBefore(now)) {
      print('⚠️ 5-min reminder time is in the past, skipping');
      return;
    }

    print('⏰ Scheduling 5-min reminder for: $reminderTime');

    final androidDetails = _createAndroidDetails(
      channelId: 'task_reminder_channel',
      channelName: 'Task Reminders',
      channelDescription: 'Important reminders for tasks due in 5 minutes',
      importance: Importance.high,
      priority: Priority.high,
      ledColor: Colors.orange,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      notificationId + 1000,
      '⚠️ Task Due in 5 Minutes!',
      '${task.title} - ${task.description.isEmpty ? "Don't forget!" : task.description}',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print('✅ 5-min reminder scheduled with ID: ${notificationId + 1000}');
  }

  Future<void> scheduleTaskNotification(Task task) async {
    await _ensureInitialized();

    try {
      print('📱 === Scheduling notification for task: ${task.title} ===');

      if (task.dueDate.isBefore(DateTime.now()) && task.repeatType == 'none') {
        print('⚠️ Task due date is in the past and not repeating, skipping');
        return;
      }

      final notificationId = task.notificationId ?? (task.id ?? 0);
      final dueDateTime =
          task.dueTime ??
          DateTime(
            task.dueDate.year,
            task.dueDate.month,
            task.dueDate.day,
            9,
            0,
          );

      print('📅 Due date/time: $dueDateTime');
      print('🆔 Notification ID: $notificationId');
      print('🔁 Repeat type: ${task.repeatType}');

      // Schedule reminder notifications
      await _scheduleFiveMinuteReminder(task, dueDateTime, notificationId);
      await _scheduleOneMinuteReminder(task, dueDateTime, notificationId);

      // Main notification with maximum visibility
      final androidDetails = _createAndroidDetails(
        channelId: 'task_channel',
        channelName: 'Task Notifications',
        channelDescription: 'Notifications for upcoming tasks',
        importance: Importance.max,
        priority: Priority.max,
        ledColor: Colors.green,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final now = tz.TZDateTime.now(tz.local);
      final scheduledDate = tz.TZDateTime.from(dueDateTime, tz.local);

      print('📅 Current TZ time: $now');
      print('📅 Scheduled TZ time: $scheduledDate');
      print('📅 Is scheduled time in future? ${scheduledDate.isAfter(now)}');

      if (task.repeatType == 'daily') {
        var nextDate = scheduledDate;
        if (!nextDate.isAfter(now)) {
          nextDate = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            now.day,
            scheduledDate.hour,
            scheduledDate.minute,
          ).add(const Duration(days: 1));
        }

        print('📅 Daily task - next occurrence: $nextDate');

        await _notifications.zonedSchedule(
          notificationId,
          '📅 ${task.title}',
          task.description.isEmpty ? 'Task is due now!' : task.description,
          nextDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );

        print('✅ Daily notification scheduled with ID: $notificationId');
      } else if (task.repeatType == 'weekly' && task.repeatDays != null) {
        print('📅 Weekly task - scheduling for days: ${task.repeatDays}');
        final days = _parseRepeatDays(task.repeatDays!);

        for (final day in days) {
          await _scheduleWeeklyNotification(
            notificationId + day,
            task,
            day,
            dueDateTime,
            notificationDetails,
          );
        }
      } else {
        // One-time notification
        if (scheduledDate.isAfter(now)) {
          await _notifications.zonedSchedule(
            notificationId,
            '📅 ${task.title}',
            task.description.isEmpty ? 'Task is due now!' : task.description,
            scheduledDate,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );

          print('✅ One-time notification scheduled with ID: $notificationId');
        } else {
          print('⚠️ Scheduled time is in the past, skipping main notification');
        }
      }

      // List all pending notifications after scheduling
      await listPendingNotifications();

      print('📱 === Notification scheduling complete ===');
    } catch (e) {
      print('❌ ERROR scheduling notification: $e');
      rethrow;
    }
  }

  Future<void> _scheduleWeeklyNotification(
    int id,
    Task task,
    int dayOfWeek,
    DateTime dueDateTime,
    NotificationDetails details,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = _getNextWeekday(now, dayOfWeek, dueDateTime);

    print('📅 Weekly notification for day $dayOfWeek: $scheduledDate');

    if (scheduledDate.isAfter(now)) {
      await _notifications.zonedSchedule(
        id,
        '📅 ${task.title}',
        task.description.isEmpty ? 'Task is due now!' : task.description,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

      print('✅ Weekly notification scheduled with ID: $id');
    }
  }

  tz.TZDateTime _getNextWeekday(
    tz.TZDateTime now,
    int dayOfWeek,
    DateTime dueTime,
  ) {
    var next = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      dueTime.hour,
      dueTime.minute,
    );

    final currentDay = now.weekday;
    final daysUntilNext = (dayOfWeek - currentDay) % 7;

    if (daysUntilNext == 0 && next.isBefore(now)) {
      next = next.add(const Duration(days: 7));
    } else {
      next = next.add(Duration(days: daysUntilNext));
    }

    return next;
  }

  List<int> _parseRepeatDays(String repeatDays) {
    try {
      final cleaned = repeatDays.replaceAll('[', '').replaceAll(']', '');
      return cleaned.split(',').map((e) => int.parse(e.trim())).toList();
    } catch (e) {
      print('❌ Error parsing repeat days: $e');
      return [];
    }
  }

  Future<void> cancelNotification(int notificationId) async {
    print('🗑️ Cancelling notification ID: $notificationId');
    await _notifications.cancel(notificationId);
    await _notifications.cancel(notificationId + 1000); // 5-min reminder
    await _notifications.cancel(notificationId + 2000); // 1-min reminder
  }

  Future<void> cancelAllNotifications() async {
    print('🗑️ Cancelling all notifications');
    await _notifications.cancelAll();
  }

  Future<void> updateTaskNotification(Task task) async {
    await _ensureInitialized();

    if (task.notificationId != null) {
      await cancelNotification(task.notificationId!);
    }
    if (!task.isCompleted) {
      await scheduleTaskNotification(task);
    }
  }
}
