import 'package:asyncstate/class/async_loader_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/fp/either.dart';
import '../../core/providers/application_providers.dart';
import '../../models/barbershop_model.dart';
import '../../models/user_model.dart';
import 'schedule_state.dart';

part 'schedule_vm.g.dart';

@riverpod
class ScheduleVm extends _$ScheduleVm {
  @override
  ScheduleState build() => ScheduleState.initial();

  void hourSelect(int hour) {
    if (hour == state.scheduleHour) {
      state = state.copyWith(scheduleHour: null);
    } else {
      state = state.copyWith(scheduleHour: hour);
    }
  }

  void dateSelect(DateTime date) {
    state = state.copyWith(scheduleDate: date);
  }

  Future<void> register({
    required UserModel userModel,
    required String clientName,
  }) async {
    final asyncLoaderHandler = AsyncLoaderHandler()..start();

    final ScheduleState(:scheduleDate, :scheduleHour) = state;
    final repository = ref.read(scheduleRepositoryProvider);
    final BarbershopModel(:id) =
        await ref.watch(getMyBarbershopProvider.future);

    final dto = (
      barbershopId: id,
      userId: userModel.id,
      clientName: clientName,
      date: scheduleDate!,
      time: scheduleHour!,
    );

    final scheduleResult = await repository.scheduleClient(dto);

    switch (scheduleResult) {
      case Success():
        state = state.copyWith(status: ScheduleStateStatus.success);
      case Failure():
        state = state.copyWith(status: ScheduleStateStatus.error);
    }

    asyncLoaderHandler.close();
  }
}
