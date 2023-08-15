import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/colors.dart';

class BarberShopLoader extends StatelessWidget {
  const BarberShopLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: ColorsConstants.brown,
        size: 60,
      ),
    );
  }
}
