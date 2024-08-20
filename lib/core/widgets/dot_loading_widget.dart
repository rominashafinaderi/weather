import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DotLoadingWidget extends StatelessWidget {
   DotLoadingWidget({Key? key, required this.size,this.color}) : super(key: key);
final double size;
   Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        size: size,
        color: color ??Colors.white,
      ),
    );
  }
}