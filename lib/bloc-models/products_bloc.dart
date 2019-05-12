import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/models/product.dart';
import 'package:rxdart/rxdart.dart';

import "dart:async";

class ProductsBloc {
  List<Product> _products = [];
  int _selectedIndex;

  var _productsListStateController = 
  BehaviorSubject<List<Product>>();
  StreamSink<List<Product>> get _inProducts => _productsListStateController.sink;
  Stream<List<Product>> get products => _productsListStateController.stream;

  BehaviorSubject<int> _productSelectedIndexStateController = 
  BehaviorSubject<int>();
  StreamSink<int> get inSelectedIndex => _productSelectedIndexStateController.sink;
  Stream<int> get selectedIndex => _productSelectedIndexStateController.stream;


  final _productQueryEventController = BehaviorSubject<ProductsQueryEvent>();
  StreamSink<ProductsQueryEvent> get productQueryEventSink => _productQueryEventController.sink;

  ProductsBloc()
  {
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
      inSelectedIndex.add(_selectedIndex);
    } else if (event is FormSubmitEvent) {
      if (_selectedIndex == null) {
        productQueryEventSink.add(CreateEvent(event.product));
      } else {
        productQueryEventSink.add(UpdateEvent(event.product));
        productQueryEventSink.add(SelectEvent(null));
      }
    }
  }

  void dispose () {
    _productsListStateController.close();
    _productQueryEventController.close();
    _productSelectedIndexStateController.close();
  }
}