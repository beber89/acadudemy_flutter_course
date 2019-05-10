import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/products_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _bloc = ProductsBloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.products,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          // home: AuthPage(),
          routes: {
            '/': (BuildContext context) => AuthPage(),
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
        );
      }
    );
  }
}
