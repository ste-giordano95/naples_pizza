import 'package:flutter/material.dart';
import 'package:naples_pizza/pages/checkout.dart';
import 'package:naples_pizza/pages/homepage/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePage.route,
      routes: {
        HomePage.route: (context) => HomePage(),
        Checkout.route: (context) => Checkout(),
      },
    );
  }
}
