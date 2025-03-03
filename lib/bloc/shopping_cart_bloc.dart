import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naples_pizza/models/product_model.dart';

class ShoppingCartBloc
    extends Bloc<ShoppingCartBlocEvent, ShoppingCartBlocState> {
  ShoppingCartBloc() : super(ShoppingCartBlocStateLoading()) {
    on<ShoppingCartBlocEventInit>((event, emit) async {
      emit(ShoppingCartBlocStateLoading());
      await Future.delayed(Duration(seconds: 2));
      emit(ShoppingCartBlocStateLoaded(products));
    });

    on<ShoppingCartBlocEventProductAddToggle>((event, emit) async {
      final product = event.product;
      final products = (state as ShoppingCartBlocStateLoaded).products;

      if (products.contains(product))
        products.firstWhere((p) => p == product).inShoppingCart =
            !product.inShoppingCart;

      emit(ShoppingCartBlocStateLoaded(products));
    });
  }
}

abstract class ShoppingCartBlocEvent {}

class ShoppingCartBlocEventInit extends ShoppingCartBlocEvent {}

class ShoppingCartBlocEventProductAddToggle extends ShoppingCartBlocEvent {
  final ProductModel product;
  ShoppingCartBlocEventProductAddToggle(this.product);
}

abstract class ShoppingCartBlocState {}

class ShoppingCartBlocStateLoading extends ShoppingCartBlocState {}

class ShoppingCartBlocStateLoaded extends ShoppingCartBlocState {
  final List<ProductModel> products;
  ShoppingCartBlocStateLoaded(this.products);
}
