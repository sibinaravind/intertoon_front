import 'package:flutter/material.dart';
import 'package:intertoons/Utils/colors.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../functions/db_functions.dart';
import '../widgets/widgets.dart';
import 'home.dart';

class navScreen extends StatefulWidget {
  const navScreen({Key? key}) : super(key: key);

  @override
  State<navScreen> createState() => _navScreenState();
}

class _navScreenState extends State<navScreen> {
  final List<Widget> _screen = [
    HomeScreen(),
    SearchEngine(),
    Cart(),
  ];
  final List<IconData> _icons = const [
    Icons.home,
    Icons.search,
    Icons.shopping_bag_outlined,
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    GetCart();
    return DefaultTabController(
        length: _icons.length,
        child: Scaffold(
          backgroundColor: AppColors.mainColor,
          body: IndexedStack(
            index: _selectedIndex,
            children: _screen,
          ),
          // _screen[_selectedIndex],
          bottomNavigationBar: SizedBox(
            height: 40,
            child: CustomTabBar(
              icons: _icons,
              selectedIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ));
  }
}
