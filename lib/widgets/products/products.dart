import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';
import 'package:acadudemy_flutter_course/bloc-models/app_bloc.dart';



class Products extends StatelessWidget {
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
  Widget build(BuildContext context) {
    Stream<List<Product>> productsStream = Provider.of<AppBloc>(context).productsBloc.outDisplayedProducts;
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, AsyncSnapshot<List<Product>> snapshot ){
        return StreamBuilder<bool>(
      stream: Provider.of<AppBloc>(context).uiBloc.outIsLoading,
      builder: (context, AsyncSnapshot<bool> uiSnapshot ){
        return uiSnapshot.connectionState == ConnectionState.waiting 
        || uiSnapshot.data ? Center(child: CircularProgressIndicator())
        : _buildProductList(snapshot.data);
    });
    });
  }
}
