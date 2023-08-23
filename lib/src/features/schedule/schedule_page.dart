import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/helpers/form_helper.dart';
import '../../core/ui/helpers/messages.dart';
import '../../core/ui/theme/barbershop_icons.dart';
import '../../core/ui/theme/colors.dart';
import '../../core/ui/widgets/avatar_widget.dart';
import '../../core/ui/widgets/hours_panel.dart';
import 'widgets/schedule_calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  var dateFormat = DateFormat('dd/mm/yyyy');
  var showCalendar = false;
  final formKey = GlobalKey<FormState>();
  final clientEC = TextEditingController();
  final dateEC = TextEditingController();

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                children: [
                  const AvatarWidget(
                    hideUploadButton: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Nome e Sobrenome',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 37),
                  TextFormField(
                    controller: clientEC,
                    onTapOutside: (_) => context.unfocus(),
                    validator: Validatorless.required('Cliente obrigatório'),
                    decoration: const InputDecoration(
                      label: Text('Cliente'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: dateEC,
                    validator: Validatorless.required(
                      'Selecione a data do agendamento',
                    ),
                    onTap: () {
                      setState(() {
                        showCalendar = true;
                        context.unfocus();
                      });
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text('Selecione uma data'),
                      hintText: 'Selecione uma data',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Icon(
                        BarbershopIcons.calendar,
                        color: ColorsConstants.brown,
                        size: 18,
                      ),
                    ),
                  ),
                  Offstage(
                    offstage: !showCalendar,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        ScheduleCalendar(
                          cancelPressed: () => setState(() {
                            showCalendar = false;
                          }),
                          okPressed: (DateTime date) {
                            setState(() {
                              dateEC.text = dateFormat.format(date);
                              showCalendar = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  HoursPanel.singleSelection(
                    startTime: 6,
                    endTime: 23,
                    onHourPressed: (value) {},
                    enabledHours: const [6, 7, 8, 9, 10, 11, 12, 13, 14, 15],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    onPressed: () {
                      switch (formKey.currentState?.validate()) {
                        case (false || null):
                          // Mostrar uma mensagem de erro
                          Messages.showError(
                            'Dados incompletos',
                            context,
                          );
                          break;
                        case (true):
                        // final EmployeeRegisterState(
                        //   workDays: List(isNotEmpty: hasWorkDays),
                        //   workHours: List(isNotEmpty: hasWorkHours)
                        // ) = ref.watch(employeeRegisterVmProvider);
                        // if (!hasWorkDays || !hasWorkHours) {
                        //   Messages.showError(
                        //     'Por favor selecione os dias da semana e horário de atendimento',
                        //     context,
                        //   );
                        //   return;
                        // }
                        // employeeRegisterVm.register(
                        //   name: nameEC.text,
                        //   email: emailEC.text,
                        //   password: passwordEC.text,
                        // );
                      }
                    },
                    child: const Text(
                      'AGENDAR',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
