import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barber_shop_loader.dart';
import 'package:dw_barbershop/src/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarberShopLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          title: 'DW Barbershop',
          navigatorObservers: [asyncNavigatorObserver],
          routes: {
            '/': (context) => const SplashPage(),
          },
        );
      },
    );
  }
}
