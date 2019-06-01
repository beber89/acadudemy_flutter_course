import 'package:acadudemy_flutter_course/bloc-models/ui_bloc.dart';
import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';
import 'package:acadudemy_flutter_course/bloc-models/app_bloc.dart';

class Products extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsState();
  }
}

class _ProductsState extends State<Products> {
  UiBloc uiBloc;
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            Center(child: Text("No products to show")),
        itemCount: 1,
      );
    }
    return productCards;
  }

  @override
  dispose() {
    // TODO: MOST RECENT CHANGE
    print("unloading");
    uiBloc.unloadScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<Product>> productsStream =
        Provider.of<AppBloc>(context).productsBloc.outDisplayedProducts;
    
    uiBloc = Provider.of<AppBloc>(context).uiBloc;
    return StreamBuilder<List<Product>>(
        stream: productsStream,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          return StreamBuilder<bool>(
              stream: uiBloc.outIsLoading,
              builder: (context, AsyncSnapshot<bool> uiSnapshot) {
                return uiSnapshot.connectionState == ConnectionState.waiting ||
                        uiSnapshot.data
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.data != null? _buildProductList(snapshot.data)
                    : _buildProductList([]);

              });
        });
  }
}
