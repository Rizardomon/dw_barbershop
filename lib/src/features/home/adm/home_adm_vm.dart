import 'package:asyncstate/asyncstate.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/fp/either.dart';
import '../../../core/providers/application_providers.dart';
import '../../../models/barbershop_model.dart';
import 'home_adm_state.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVm extends _$HomeAdmVm {
  @override
  Future<HomeAdmState> build() async {
    final repository = ref.read(userRepositoryProvider);
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);

    final employeesResult = await repository.getEmployees(barbershopId);

    switch (employeesResult) {
      case Success(value: final employees):
        return HomeAdmState(
          status: HomeAdmStateStatus.loaded,
          employees: employees,
        );

      case Failure():
        return HomeAdmState(
          status: HomeAdmStateStatus.error,
          employees: [],
        );
    }
  }

  Future<void> logout() async => ref.read(logoutProvider.future).asyncLoader();
}
