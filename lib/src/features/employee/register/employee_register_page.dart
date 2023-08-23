import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/providers/application_providers.dart';
import '../../../core/ui/helpers/form_helper.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/theme/colors.dart';
import '../../../core/ui/widgets/avatar_widget.dart';
import '../../../core/ui/widgets/barber_shop_loader.dart';
import '../../../core/ui/widgets/hours_panel.dart';
import '../../../core/ui/widgets/week_days_panel.dart';
import '../../../models/barbershop_model.dart';
import 'employee_register_state.dart';
import 'employee_register_vm.dart';

class EmployeeRegisterPage extends ConsumerStatefulWidget {
  const EmployeeRegisterPage({super.key});

  @override
  ConsumerState<EmployeeRegisterPage> createState() =>
      _EmployeeRegisterPageState();
}

class _EmployeeRegisterPageState extends ConsumerState<EmployeeRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  var registerAdm = false;

  @override
  void dispose() {
    nameEC.dispose();
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final employeeRegisterVm = ref.watch(employeeRegisterVmProvider.notifier);
    final barbershopAsyncValue = ref.watch(getMyBarbershopProvider);

    ref.listen(
      employeeRegisterVmProvider.select((state) => state.status),
      (_, status) {
        switch (status) {
          case EmployeeRegisterStateStatus.initial:
            break;
          case EmployeeRegisterStateStatus.success:
            Messages.showSuccess('Colaborador cadastrado com sucesso', context);
            Navigator.of(context).pop();
          case EmployeeRegisterStateStatus.error:
            Messages.showError('Erro ao registrar colaborador', context);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar colaborador'),
      ),
      body: barbershopAsyncValue.when(
        loading: () => const Center(
          child: BarberShopLoader(),
        ),
        error: (error, stackTrace) {
          log(
            'Erro ao carregar a página',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
            child: Text('Erro ao carregar a página'),
          );
        },
        data: (barbershopModel) {
          final BarbershopModel(:openingDays, :openingHours) = barbershopModel;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Center(
                  child: Column(
                    children: [
                      const AvatarWidget(),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            activeColor: ColorsConstants.brown,
                            value: registerAdm,
                            onChanged: (value) {
                              setState(() {
                                registerAdm = !registerAdm;
                                employeeRegisterVm.setRegisterAdm(registerAdm);
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Sou administrador e quero me cadastrar como colaborador',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Offstage(
                        offstage: registerAdm,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: nameEC,
                              onTapOutside: (_) => context.unfocus(),
                              validator: registerAdm
                                  ? null
                                  : Validatorless.required('Nome obrigatório'),
                              decoration: const InputDecoration(
                                label: Text('Nome'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: emailEC,
                              onTapOutside: (_) => context.unfocus(),
                              validator: registerAdm
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                        'E-mail obrigatório',
                                      ),
                                      Validatorless.email('E-mail inválido'),
                                    ]),
                              decoration: const InputDecoration(
                                label: Text('E-mail'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: passwordEC,
                              onTapOutside: (_) => context.unfocus(),
                              validator: registerAdm
                                  ? null
                                  : Validatorless.multiple([
                                      Validatorless.required(
                                        'Senha obrigatória',
                                      ),
                                      Validatorless.min(6, 'Senha inválida'),
                                    ]),
                              obscureText: true,
                              decoration: const InputDecoration(
                                label: Text('Senha'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      WeekDaysPanel(
                        enabledDays: openingDays,
                        onDayPressed: employeeRegisterVm.addOrRemoveWorkDays,
                      ),
                      const SizedBox(height: 24),
                      HoursPanel(
                        startTime: 6,
                        endTime: 23,
                        onHourPressed: employeeRegisterVm.addOrRemoveWorkHours,
                        enabledHours: openingHours,
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
                                'Formulário inválido',
                                context,
                              );
                              break;
                            case (true):
                              final EmployeeRegisterState(
                                workDays: List(isNotEmpty: hasWorkDays),
                                workHours: List(isNotEmpty: hasWorkHours)
                              ) = ref.watch(employeeRegisterVmProvider);
                              if (!hasWorkDays || !hasWorkHours) {
                                Messages.showError(
                                  'Por favor selecione os dias da semana e horário de atendimento',
                                  context,
                                );
                                return;
                              }
                              employeeRegisterVm.register(
                                name: nameEC.text,
                                email: emailEC.text,
                                password: passwordEC.text,
                              );
                          }
                        },
                        child: const Text(
                          'CADASTRAR COLABORADOR',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
