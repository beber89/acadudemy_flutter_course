import 'package:flutter/material.dart';

import './product_edit.dart';
import '../models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class ProductListPage extends StatelessWidget {
  final ProductsBloc _bloc = BlocProvider.getBloc<ProductsBloc>();
  Widget _buildEditButton(
      BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        _bloc.productQueryEventSink.add(SelectEvent(index));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("[Widget ProductListPage");
    return StreamBuilder(
      stream: _bloc.products,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        final products = snapshot.data;
        print("inside productlist snapshot");
        print(products);
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(products[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  _bloc.productQueryEventSink.add(SelectEvent(index));
                  _bloc.productQueryEventSink.add(DeleteEvent());
                } else if (direction == DismissDirection.startToEnd) {
                  print('Swiped start to end');
                } else {
                  print('Other swiping');
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(products[index].image),
                    ),
                    title: Text(products[index].title),
                    subtitle:
                        Text('\$${products[index].price.toString()}'),
                    trailing: _buildEditButton(context, index),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: products.length,
        );
      }
    );
  }
}
