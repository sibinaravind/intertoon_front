import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intertoons/Utils/colors.dart';

class CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isBottomIndicator;

  const CustomTabBar({
    Key? key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
    this.isBottomIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
        indicatorPadding: EdgeInsets.zero,
        onTap: onTap,
        indicator: BoxDecoration(
            border: Border(
                top: BorderSide(color: AppColors.mainGreenColor, width: 4.0))),
        tabs: icons
            .asMap()
            .map((i, e) => MapEntry(
                i,
                Tab(
                    icon: Icon(
                  e,
                  color: i == selectedIndex ? Colors.white : Colors.white38,
                  size: 25.0,
                ))))
            .values
            .toList());
  }
}
