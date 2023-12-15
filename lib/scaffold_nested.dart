import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// This widget includes the navbars based on the device dimensions
// it inserts the proper content as "navigationShell" based on the
// route
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // support navigating to the initial location when tapping the
      // item that is already active:
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // get the current screen width, widget rebuilds when the width changes
    // and the mediaquery conditions need to be fullfilled (meaning, switch
    // bottom navbar to rail or vice versa)
    final currentWidth = MediaQuery.of(context).size.width;
    // list of supported destinations to be shown on the navbar
    List<NavigationDestination> destinations = const [
      NavigationDestination(icon: Icon(Icons.search), label: "Search songs"),
      NavigationDestination(icon: Icon(Icons.add), label: "Create song"),
      NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      NavigationDestination(icon: Icon(Icons.settings), label: "settings")
    ];
    if (currentWidth < 600) {
      // show bottom navbar on mobile devices
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          destinations: destinations,
          onDestinationSelected: _goBranch,
          indicatorColor: Colors.deepOrange,
        ),
      );
    } else {
      // use NavRail sidebar on tablet / desktop
      return Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _goBranch,
              labelType: NavigationRailLabelType.all,
              indicatorColor: Colors.deepOrange,
              destinations: destinations.map((destination) {
                return NavigationRailDestination(
                  icon: destination.icon,
                  label: Text(destination.label),
                );
              }).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 2),
            Expanded(
              child: Center(
                child: navigationShell,
              ),
            )
          ],
        ),
      );
    }
  }
}
