import 'package:ebook/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/theme_config.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key? key,  this.color = purpleColor}) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return   Center(
      child: SizedBox(
          child: SpinKitCircle(
            color: color,
            size: 50.0,
            duration: const Duration(seconds: 1),
          )),
    );
  }
}