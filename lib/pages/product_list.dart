import 'package:flutter/material.dart';

import './product_edit.dart';
import '../models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:provider/provider.dart';
import 'package:acadudemy_flutter_course/bloc-models/ui_bloc.dart';

class _ProductListPageState extends State<ProductListPage> {
  ProductsBloc bloc;
  UiBloc uiBloc;
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
                    bloc.selectItemWithId(snapshot.data[index].id).then((_) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProductEditPage();
                          },
                        ),
                      );
                    });
                  },
                ));
  }

  @override
  Widget build(BuildContext context) {
    print("[Widget ProductListPage]");
    bloc = Provider.of<ProductsBloc>(context);
    uiBloc = Provider.of<UiBloc>(context);
    return StreamBuilder<bool>(
        stream: uiBloc.outIsLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> uiSnapshot) {
          return StreamBuilder<List<Product>>(
              stream: bloc.products,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                final products = snapshot.data;
                return products != null
                    ? _buildListView(products, uiSnapshot)
                    : Container();
              });
        });
  }

  Widget _buildListView(products, uiSnapshot) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(products[index].id),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              bloc.selectItemWithId(products[index].id).then((_) {
                        bloc.deleteItem().then((success) {
                          if (!success) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Something went wrong'),
                                    content: Text('Please try again!'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Okay'),
                                      )
                                    ],
                                  );
                                });
                          }
                        });
                      });
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
                  backgroundImage: NetworkImage(products[index].image),
                ),
                title: Text(products[index].title),
                subtitle: Text('\$${products[index].price.toString()}'),
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
}

class ProductListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductListPageState();
  }
}
