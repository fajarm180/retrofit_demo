import 'package:flutter/material.dart';

class Menu {
  final IconData icon;
  final String title;
  final String? route;

  Menu({
    required this.icon,
    required this.title,
    this.route,
  });
}

class XBaseLayout extends StatelessWidget {
  const XBaseLayout({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.pageTitle,
  });

  final String? pageTitle;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final menus = [
      Menu(icon: Icons.menu, title: 'Menu'),
      Menu(
        icon: Icons.home,
        title: 'Home',
        route: 'product',
      ),
      Menu(
        icon: Icons.input,
        title: 'Input Components',
        route: 'input_components',
      ),
      Menu(
        icon: Icons.calendar_month,
        title: 'Calendar 2 Components',
        route: 'calendar_input_comp',
      ),
    ];

    return Scaffold(
      appBar: appBar ??
          AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(pageTitle ?? ''),
          ),
      body: body,
      floatingActionButton: floatingActionButton,
      drawer: Drawer(
        shape: RoundedRectangleBorder(),
        child: ListView.separated(
          itemCount: menus.length,
          separatorBuilder: (context, index) =>
              (index == 0) ? const Divider() : Container(),
          itemBuilder: (c, i) => ListTile(
            dense: true,
            leading: Icon(menus[i].icon),
            title: Text(menus[i].title),
            onTap: (menus[i].route ?? '').isNotEmpty
                ? () => Navigator.pushReplacementNamed(context, menus[i].route!)
                : null,
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
