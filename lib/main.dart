import 'package:flutter/material.dart';
import 'package:retrofit_demo/presentations/views/date_widget_demo/calendart_page.dart';
import 'package:retrofit_demo/presentations/views/date_widget_demo/material_page.dart';
import 'package:retrofit_demo/presentations/views/date_widget_demo/sync_func_page.dart';
import 'package:retrofit_demo/presentations/views/form.dart';
import 'package:retrofit_demo/presentations/views/product.dart';
import 'package:retrofit_demo/shared/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: _inputDecorationTheme(),
      ),
      home: ProductsPage(),
      builder: (context, child) => SafeArea(
        top: false,
        child: child ?? Container(),
      ),
      routes: {
        'product': (context) => const ProductsPage(),
        'product_form': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as JSON?;
          return ProductFormPage(product: args?['product']);
        },
        'calendar_date_widget': (context) => const CalendarDatePage(),
        'material_date_widget': (context) => const MatDateWidgetPage(),
        'sync_func_date_widget': (context) => const SFDateWidgetPage(),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    const OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      gapPadding: 0,
    );

    const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      gapPadding: 0,
    );

    return const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 14),
      disabledBorder: outlineInputBorder,
      enabledBorder: outlineInputBorder,
      focusedBorder: focusedBorder,
      border: outlineInputBorder,
      alignLabelWithHint: true,
      hintStyle: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
