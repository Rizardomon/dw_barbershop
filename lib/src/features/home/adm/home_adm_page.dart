import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ui/theme/barbershop_icons.dart';
import '../../../core/ui/theme/colors.dart';
import '../../../core/ui/widgets/barber_shop_loader.dart';
import '../widgets/home_header.dart';
import 'home_adm_vm.dart';
import 'widgets/home_employee_tile.dart';

class HomeAdmPage extends ConsumerWidget {
  const HomeAdmPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeAdmVmProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstants.brown,
        onPressed: () async {
          await Navigator.of(context).pushNamed('/employee/register');
          ref.invalidate(homeAdmVmProvider);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          maxRadius: 12,
          child: Icon(
            BarbershopIcons.addEmployee,
            color: ColorsConstants.brown,
          ),
        ),
      ),
      body: homeState.when(
        loading: () => const BarberShopLoader(),
        error: (error, stackTrace) {
          log(
            'Erro ao carregar colaboradores',
            error: error,
            stackTrace: stackTrace,
          );
          return const Center(
            child: Text('Erro ao carregar pagina'),
          );
        },
        data: (data) => CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: HomeHeader(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    HomeEmployeeTile(employee: data.employees[index]),
                childCount: data.employees.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
