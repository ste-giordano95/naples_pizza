import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naples_pizza/app.dart';
import 'package:naples_pizza/bloc/shopping_cart_bloc.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ShoppingCartBloc(),
    ),
  ], child: App()));
}
