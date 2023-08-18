import 'package:asyncstate/widget/async_state_builder.dart';
import 'package:flutter/material.dart';

import 'core/ui/barbershop_nav_global_key.dart';
import 'core/ui/theme/barbershop_theme.dart';
import 'core/ui/widgets/barber_shop_loader.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/user/user_register_page.dart';
import 'features/splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AsyncStateBuilder(
      customLoader: const BarberShopLoader(),
      builder: (asyncNavigatorObserver) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DW Barbershop',
          theme: BarbershopTheme.themeData,
          navigatorObservers: [asyncNavigatorObserver],
          navigatorKey: BarbershopNavGlobalKey.instance.navKey,
          routes: {
            '/': (context) => const SplashPage(),
            '/auth/login': (context) => const LoginPage(),
            '/auth/register/user': (context) => const UserRegisterPage(),
            '/home/adm': (context) => const Text('ADM'),
            '/home/employee': (context) => const Text('EMPLOYEE'),
            '/auth/register/barbershop': (context) => const Text('BARBERSHOP'),
          },
        );
      },
    );
  }
}
