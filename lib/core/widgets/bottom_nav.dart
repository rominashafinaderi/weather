import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  PageController Controller;

  BottomNav({Key? key, required this.Controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    var primaryColor = Colors.white;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: primaryColor,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  Controller.animateToPage(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                icon: const Icon(Icons.home)),
            const SizedBox(),
            IconButton(
                onPressed: () {
                  Controller.animateToPage(1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                icon: const Icon(Icons.bookmark)),
          ],
        ),
      ),
    );
  }
}
