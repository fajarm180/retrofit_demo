import 'package:flutter/material.dart';

class Menu {
  final IconData icon;
  final String title;
  final String? route;
  final List<Menu> children;

  Menu({
    required this.icon,
    required this.title,
    this.route,
    this.children = const [],
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
        icon: Icons.subdirectory_arrow_right,
        title: 'Date Widget Demo',
        children: [
          Menu(
            icon: Icons.calendar_month,
            title: 'Calendar2 Date',
            route: 'calendar_date_widget',
          ),
          Menu(
            icon: Icons.calendar_today,
            title: 'Material Date',
            route: 'material_date_widget',
          ),
          Menu(
            icon: Icons.edit_calendar,
            title: 'SyncFunc Date',
            route: 'sync_func_date_widget',
          ),
        ],
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
          padding: EdgeInsets.all(8.0).copyWith(top: kToolbarHeight / 2),
          itemCount: menus.length,
          separatorBuilder: (context, index) =>
              (index == 0) ? const Divider() : Container(),
          itemBuilder: (c, i) => MenuTIle(item: menus[i]),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class MenuTIle extends StatelessWidget {
  final Menu item;
  final double indent;

  const MenuTIle({
    super.key,
    required this.item,
    this.indent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final leading = Icon(item.icon);

    final title = Text(item.title);

    if (item.children.isEmpty) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.only(left: indent),
        leading: leading,
        title: title,
        onTap: (item.route ?? '').isNotEmpty
            ? () => Navigator.pushReplacementNamed(context, item.route!)
            : null,
      );
    }

    return ExpansionTile(
      dense: true,
      shape: LinearBorder(),
      tilePadding: EdgeInsets.only(left: indent),
      leading: leading,
      title: title,
      children: item.children
          .map((e) => MenuTIle(
                item: e,
                indent: indent + 25,
              ))
          .toList(),
    );
  }
}
