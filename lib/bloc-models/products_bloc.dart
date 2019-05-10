import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/models/product.dart';

import "dart:async";

class ProductsBloc {
  List<Product> _products;

  final _productsListStateController = StreamController<List<Product>> ();
  StreamSink<List<Product>> get _inProducts => _productsListStateController.sink;
  Stream<List<Product>> get products => _productsListStateController.stream;

  final _productQueryEventController = StreamController<ProductsQueryEvent>();
  Sink<ProductsQueryEvent> get productQueryEventSink => _productQueryEventController.sink;

  ProductsBloc() {
    _productQueryEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(ProductsQueryEvent event) {
    if(event is CreateEvent) {
      _products.add(event.product);
      _inProducts.add(_products);
    }
    else if (event is UpdateEvent) {
      _products[event.index] = event.updatedProduct;
    } else if (event is DeleteEvent) {
      _products.removeAt(event.index);
    }
  }

  void dispose () {
    _productsListStateController.close();
    _productQueryEventController.close();
  }
}