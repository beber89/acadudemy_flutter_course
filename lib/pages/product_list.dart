import 'package:flutter/material.dart';

import './product_edit.dart';
import '../models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatelessWidget {
  ProductsBloc bloc;
  Widget _buildEditButton(BuildContext context, int index) {
    return StreamBuilder<List<Product>>(
        stream: Provider.of<ProductsBloc>(context).products,
        builder:
            (BuildContext context, AsyncSnapshot<List<Product>> snapshot) =>
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // FIXME: needs a promise , might solve a bug
                    // Provider.of<ProductsBloc>(context)
                    //     .productQueryEventSink
                    //     .add(SelectEvent(snapshot.data[index].id));
                    bloc
                        .selectItemWithId(snapshot.data[index].id)
                        .then((_) => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ProductEditPage();
                                },
                              ),
                            ));
                  },
                ));
  }

  @override
  Widget build(BuildContext context) {
    print("[Widget ProductListPage]");
    bloc = Provider.of<ProductsBloc>(context);
    return StreamBuilder<List<Product>>(
        stream: Provider.of<ProductsBloc>(context).products,
        builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
          final products = snapshot.data;
          return products != null
              ? ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(products[index].id),
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.endToStart) {
                          bloc.productQueryEventSink
                              .add(SelectEvent(products[index].id));
                          bloc.productQueryEventSink.add(DeleteEvent());
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
                              backgroundImage:
                                  NetworkImage(products[index].image),
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
                )
              : Container();
        });
  }
}
