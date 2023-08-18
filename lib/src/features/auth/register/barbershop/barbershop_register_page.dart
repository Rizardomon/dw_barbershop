import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

import '../../../../core/ui/helpers/form_helper.dart';
import '../../../../core/ui/helpers/messages.dart';
import '../../../../core/ui/widgets/hours_panel.dart';
import '../../../../core/ui/widgets/week_days_panel.dart';

class BarbershopRegisterPage extends StatefulWidget {
  const BarbershopRegisterPage({super.key});

  @override
  State<BarbershopRegisterPage> createState() => _BarbershopRegisterPageState();
}

class _BarbershopRegisterPageState extends State<BarbershopRegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameEC = TextEditingController();
  final emailEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar estabelecimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameEC,
                onTapOutside: (_) => context.unfocus(),
                validator: Validatorless.required('Nome obrigatório'),
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: emailEC,
                onTapOutside: (_) => context.unfocus(),
                validator: Validatorless.multiple([
                  Validatorless.required('E-mail obrigatório'),
                  Validatorless.email('E-mail inválido'),
                ]),
                decoration: const InputDecoration(
                  label: Text('E-mail'),
                ),
              ),
              const SizedBox(height: 24),
              const WeekDaysPanel(),
              const SizedBox(height: 24),
              const HoursPanel(
                startTime: 6,
                endTime: 23,
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
                    // userRegisterVm.register(
                    //   name: nameEC.text,
                    //   email: emailEC.text,
                    //   password: passwordEC.text,
                    // );
                  }
                },
                child: const Text(
                  'CADASTRAR ESTABELECIMENTO',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
