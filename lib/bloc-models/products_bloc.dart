import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/models/product.dart';
import "package:bloc_pattern/bloc_pattern.dart";

import "dart:async";

class ProductsBloc extends BlocBase {
  List<Product> _products = [];
  int _selectedIndex;
  Product _selectedProduct;

  var _productsListStateController = 
  StreamController<List<Product>>.broadcast();
  Sink<List<Product>> get _inProducts => _productsListStateController.sink;
  Stream<List<Product>> get products => _productsListStateController.stream;

  final StreamController<int> _productSelectedIndexStateController = 
  StreamController<int>.broadcast();
  StreamSink<int> get inSelectedIndex => _productSelectedIndexStateController.sink;
  Stream<int> get selectedIndex => _productSelectedIndexStateController.stream;

  final _selectedProductStateController = StreamController<Product> ();
  StreamSink<Product> get _inSelectedProduct => _selectedProductStateController.sink;
  Stream<Product> get selectedProduct => _selectedProductStateController.stream;

  final _productQueryEventController = StreamController<ProductsQueryEvent>();
  Sink<ProductsQueryEvent> get productQueryEventSink => _productQueryEventController.sink;

  ProductsBloc()
  {
    print("[ProductsBloc]");
    // print("_producs in ProductsBloc");
    _productQueryEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ProductsQueryEvent event) {
    if(event is CreateEvent) {
      _products.add(event.product);
      _inProducts.add(_products);
    }
    else if (event is UpdateEvent) {
      _products[_selectedIndex] = event.updatedProduct;
      _inProducts.add(_products);
    } else if (event is DeleteEvent) {
      _products.removeAt(_selectedIndex);
      _inProducts.add(_products);
    } else if(event is SelectEvent) {
      _selectedIndex = event.index;
      _selectedProduct = _products[_selectedIndex];
      inSelectedIndex.add(_selectedIndex);
      _inSelectedProduct.add(_selectedProduct);
    } else if (event is FormSubmitEvent) {
      if (_selectedIndex == null) {
        productQueryEventSink.add(CreateEvent(event.product));
      } else {
        productQueryEventSink.add(UpdateEvent(event.product));
      }
    } else if(event is InitEvent) {
      _products = [];
      _inProducts.add(_products);
    }
  }

  @override
  void dispose () {
    _productsListStateController.close();
    _productQueryEventController.close();
    _productSelectedIndexStateController.close();
    _selectedProductStateController.close();
  }
}