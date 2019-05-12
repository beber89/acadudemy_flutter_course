import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';


class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    print(products);
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
    print('[Products Widget] build()');
    final ProductsBloc _bloc = BlocProvider.getBloc<ProductsBloc>();
    print("_bloc returned by provider is: ");
    print(_bloc);
    return StreamBuilder(
      stream: _bloc.products,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot ){
        print("snapshot");
        print(snapshot.data);
        if(snapshot.data != null) {
          return _buildProductList(snapshot.data);
        }
        return Container();
    });
  }
}
