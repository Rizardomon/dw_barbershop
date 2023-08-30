import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../models/schedule_model.dart';

class AppointmentDs extends CalendarDataSource {
  final List<ScheduleModel> schedules;

  AppointmentDs({
    required this.schedules,
  });

  @override
  List<dynamic>? get appointments => schedules.map(
        (schedule) {
          final ScheduleModel(
            date: DateTime(:year, :month, :day),
            :hour,
            :clientName
          ) = schedule;

          final startTime = DateTime(year, month, day, hour, 0, 0);
          final endTime = DateTime(year, month, day, hour + 1, 0, 0);

          return Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: clientName,
          );
        },
      ).toList();
}
