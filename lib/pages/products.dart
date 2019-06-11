import 'package:acadudemy_flutter_course/pages/auth.dart';
import 'package:flutter/material.dart';

import '../widgets/products/products.dart';
import 'package:provider/provider.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/widgets/ui_elements/favourite_toggle.dart';
import 'package:acadudemy_flutter_course/bloc-models/app_bloc.dart';
import 'package:acadudemy_flutter_course/widgets/ui_elements/logout_list_tile.dart';

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
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<AppBloc>(context).authBloc.userStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState != ConnectionState.waiting 
          && snapshot.data == null) {
            return AuthPage();
          }
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
                      onPressed: (_) => Provider.of<AppBloc>(context)
                          .productsBloc
                          .productQueryEventSink
                          .add(ToggleDisplayedItems()))
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Provider.of<AppBloc>(context)
                      .productsBloc
                      .fetchProductsFromServer()
                      .catchError((error) {
                    print("catching ... ");
                    Provider.of<AppBloc>(context).authBloc.addUser(null);
                    return Navigator.pushReplacementNamed(context, '/');
                  });
                },
                child: Products(),
              ));
        });
  }
}

class ProductsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductsPageState();
  }
}
