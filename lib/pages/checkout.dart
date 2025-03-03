import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naples_pizza/bloc/shopping_cart_bloc.dart';
import 'package:naples_pizza/models/product_model.dart';

class Checkout extends StatelessWidget {
  static const route = '/checkout';
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShoppingCartBloc, ShoppingCartBlocState>(
        listener: (context, state) {
          final products = (state as ShoppingCartBlocStateLoaded).products;
          final productsInShoppingCart =
              products.where((it) => it.inShoppingCart).toList();

          if (productsInShoppingCart.isEmpty) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(appBar: appBar(), body: body()));
  }

  CustomScrollView body() {
    return CustomScrollView(
      slivers: [
        sectionProductList(),
        sectionCostRecap(),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Checkout'),
      centerTitle: true,
    );
  }

  Widget sectionProductList() =>
      BlocBuilder<ShoppingCartBloc, ShoppingCartBlocState>(
          builder: (context, state) {
        late List<ProductModel> productsInShoppingCart;
        if (state is ShoppingCartBlocStateLoaded) {
          productsInShoppingCart = state.products
              .where((element) => element.inShoppingCart)
              .toList();
          if (productsInShoppingCart.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    productListTile(context, productsInShoppingCart[index]),
                childCount: productsInShoppingCart.length,
              ),
            );
          } else {
            //Navigator.pushNamed(context, HomePage.route);
            return SliverToBoxAdapter(child: Text('Error no products'));
          }
        } else {
          return SliverToBoxAdapter(
              child: Text('Error please close and re-open app'));
        }
      });

  ListTile productListTile(BuildContext context, ProductModel product) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      subtitle: Text(product.price.toStringAsFixed(2)),
      trailing: IconButton(
        onPressed: () {
          BlocProvider.of<ShoppingCartBloc>(context)
              .add(ShoppingCartBlocEventProductAddToggle(product));
        },
        icon: Icon(Icons.delete),
      ),
    );
  }

  Widget sectionCostRecap() => SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              checkoutRow('Subtotal', 19.90),
              const SizedBox(height: 8),
              checkoutRow('Shipping', 0.00),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Totale', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('19.90', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: MaterialButton(
                  onPressed: () {},
                  color: Colors.amber,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Completa acquisto!'),
                      SizedBox(width: 8),
                      Icon(Icons.shopping_cart),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Row checkoutRow(String title, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(price.toStringAsFixed(2)),
      ],
    );
  }
}
