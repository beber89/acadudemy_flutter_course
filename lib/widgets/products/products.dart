import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:provider/provider.dart';


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
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    Stream<List<Product>> productsStream = Provider.of<ProductsBloc>(context).products;
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, AsyncSnapshot<List<Product>> snapshot ){
        return snapshot.data != null? 
        _buildProductList(snapshot.data) : Container();
    });
  }
}
