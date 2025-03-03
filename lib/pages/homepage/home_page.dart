import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naples_pizza/bloc/shopping_cart_bloc.dart';
import 'package:naples_pizza/models/product_model.dart';
import 'package:naples_pizza/pages/checkout.dart';

class HomePage extends StatefulWidget {
  static const route = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ShoppingCartBloc>(context).add(ShoppingCartBlocEventInit());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: Stack(
          children: [
            sectionProducts(),
            floatingButton(),
          ],
        ));
  }

  AppBar appBar() {
    return AppBar(
      title: Column(
        children: const [
          Text('Naples Pizza'),
          Text(
            'spedizione gratuita',
            style: TextStyle(fontSize: 12, letterSpacing: 2),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget sectionProducts() =>
      BlocBuilder<ShoppingCartBloc, ShoppingCartBlocState>(
          builder: (context, state) {
        if (state is ShoppingCartBlocStateLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        } else {
          final products = (state as ShoppingCartBlocStateLoaded).products;

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 5,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => ProductCard(products[index]),
          );
        }
      });

  Widget ProductCard(ProductModel product) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Image.network(product.imageUrl),
            )),
            const SizedBox(height: 16),
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.price.toStringAsFixed(2),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MaterialButton(
              onPressed: () {
                BlocProvider.of<ShoppingCartBloc>(context)
                    .add(ShoppingCartBlocEventProductAddToggle(product));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black12),
              ),
              child: Text(product.inShoppingCart
                  ? 'Rimuovi dal carrello'
                  : 'Aggiungi al carrello'),
            ),
          ],
        ),
      );

  Widget floatingButton() =>
      BlocBuilder<ShoppingCartBloc, ShoppingCartBlocState>(
          builder: (context, state) {
        if (state is ShoppingCartBlocStateLoading) {
          return const SizedBox();
        } else {
          final allProducts = (state as ShoppingCartBlocStateLoaded).products;
          final shoppingCartProducts =
              allProducts.where((product) => product.inShoppingCart).toList();

          if (shoppingCartProducts.isEmpty) {
            return const SizedBox();
          } else {
            return Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: MaterialButton(
                onPressed: () => Navigator.pushNamed(context, Checkout.route),
                color: Colors.amber,
                height: 50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Completa acquisto (${shoppingCartProducts.length})'),
                    SizedBox(width: 8),
                    Icon(Icons.shopping_cart),
                  ],
                ),
              ),
            );
          }
        }
      });
}
