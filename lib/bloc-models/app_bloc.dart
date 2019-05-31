
import 'package:acadudemy_flutter_course/bloc-models/auth_bloc.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:acadudemy_flutter_course/bloc-models/ui_bloc.dart';


class AppBloc {
  AuthBloc _auth;
  ProductsBloc _products;
  UiBloc _ui;

  AppBloc():
  _auth = AuthBloc(), 
  _products = ProductsBloc(),
  _ui = UiBloc()
  {
    _products.uiLoadStream.listen((isLoading) => _ui.inIsLoading.add(isLoading));
    _auth.userStream.listen((newUser) {
      _products.assignToken(newUser != null? newUser.token:null);
    });
  }

  AuthBloc get authBloc => _auth;
  ProductsBloc get productsBloc => _products;
  UiBloc get uiBloc => _ui;

  dispose() {
    _auth.dispose();
    _products.dispose();
    _ui.dispose();
  }

}
