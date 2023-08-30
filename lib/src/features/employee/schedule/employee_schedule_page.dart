import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/ui/theme/colors.dart';
import '../../../core/ui/widgets/barber_shop_loader.dart';
import '../../../models/user_model.dart';
import 'appointment_ds.dart';
import 'employee_schedule_vm.dart';

class EmployeeSchedulePage extends ConsumerStatefulWidget {
  const EmployeeSchedulePage({super.key});

  @override
  ConsumerState<EmployeeSchedulePage> createState() =>
      _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends ConsumerState<EmployeeSchedulePage> {
  late DateTime dateSelected;
  var ignoreFirstLoad = true;

  @override
  void initState() {
    final DateTime(:year, :month, :day) = DateTime.now();
    dateSelected = DateTime(year, month, day, 0, 0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel(:id, :name) =
        ModalRoute.of(context)!.settings.arguments as UserModel;
    final scheduleAsync =
        ref.watch(employeeScheduleVmProvider(id, dateSelected));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 44),
          scheduleAsync.when(
            loading: () {
              return const BarberShopLoader();
            },
            error: (error, stackTrace) {
              log(
                'Erro ao carregar agendamentos',
                error: error,
                stackTrace: stackTrace,
              );
              return const Center(
                child: Text('Erro ao carregar agendamentos'),
              );
            },
            data: (schedules) {
              return Expanded(
                child: SfCalendar(
                  allowViewNavigation: true,
                  view: CalendarView.day,
                  showNavigationArrow: true,
                  todayHighlightColor: ColorsConstants.brown,
                  showDatePickerButton: true,
                  showTodayButton: true,
                  dataSource: AppointmentDs(schedules: schedules),
                  appointmentBuilder: (context, calendarAppointmentDetails) {
                    return Container(
                      decoration: BoxDecoration(
                        color: ColorsConstants.brown,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          calendarAppointmentDetails.appointments.first.subject,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                  onViewChanged: (viewChangedDetails) {
                    if (ignoreFirstLoad) {
                      ignoreFirstLoad = false;
                      return;
                    }
                    ref
                        .read(
                          employeeScheduleVmProvider(id, dateSelected).notifier,
                        )
                        .changeDate(id, viewChangedDetails.visibleDates.first);
                  },
                  onTap: (calendarTapDetails) {
                    if (calendarTapDetails.appointments != null &&
                        calendarTapDetails.appointments!.isNotEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Cliente: ${calendarTapDetails.appointments?.first.subject}',
                                  ),
                                  Text(
                                    'Horário: ${dateFormat.format(calendarTapDetails.date ?? DateTime.now())}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
