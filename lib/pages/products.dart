import 'package:flutter/material.dart';

import '../widgets/products/products.dart';
import 'package:provider/provider.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/widgets/ui_elements/favourite_toggle.dart';

class _ProductsPageState extends State<ProductsPage> {
  bool isFavouriteList = false;
  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(isFavouriteList? Icons.favorite:Icons.favorite_border),
          //   onPressed: () {
          //     setState(() {
          //       Provider.of<ProductsBloc>(context).productQueryEventSink.add(ToggleDisplayedItems());
          //       isFavouriteList = !isFavouriteList;
          //     });
          //   },
          // ),
          FavouriteToggle(
            onPressed: () => Provider.of<ProductsBloc>(context).productQueryEventSink.add(ToggleDisplayedItems()) 
          )
        ],
      ),
      body: Products(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsPageState();
  }

}
