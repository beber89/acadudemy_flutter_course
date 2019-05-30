//FIXME: BUG: related to view, in an assert statement

//TODO: Things to Refactor:
// - bloc private values assigned automatically by listening to outstream
// - ui_bloc.dart implements isLoading feature for pages.
// - ui experience: delay one second before showing spinner

//TODO: Stuff done by Max for Authentication
// [x] add signin / signup
// [x] Auth token for post, get, delete, put
// [x] persistent token
// [x] signout
// [ ] auto signout: consider expires in
// [ ] favourite appears by user, do it with server

//TODO: Stuff done in scoped_model branch by Max for http
// [x] http post, get, delete, put
// [x] refresh spinner
// [x] id of products from server
// [x] add loading feature while creating and updating product
// [x] fix bug/exception handling
// [ ] add loading for deletion item

import 'package:flutter/material.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import 'package:provider/provider.dart';
import 'bloc-models/app_bloc.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AppBloc>(
        builder: (_) => AppBloc(),
        dispose: (_, value) => value.dispose(),
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          // home: AuthPage(),
          routes: {
            '/': (BuildContext context) => StreamBuilder<User>(
                stream: Provider.of<AppBloc>(context).authBloc.userStream,
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return snapshot.data == null ? AuthPage() : ProductsPage();
                }),
            '/products': (BuildContext context) => ProductsPage(),
            '/admin': (BuildContext context) => ProductsAdminPage(),
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(index),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => ProductsPage());
          },
        ));
  }
}
