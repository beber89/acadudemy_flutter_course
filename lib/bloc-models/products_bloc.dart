import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/models/product.dart';
import 'package:rxdart/rxdart.dart';

import "dart:async";

class ProductsBloc {
  List<Product> _products = [];
  int _selectedIndex;
  bool _isFavouriteList=false;
  Map<int, int> _modelIndexToDisplayIndex = {};

  var _productsListStateController = 
  BehaviorSubject<List<Product>>();
  StreamSink<List<Product>> get _inProducts => _productsListStateController.sink;
  Stream<List<Product>> get products => _productsListStateController.stream;

  BehaviorSubject<List<Product>> _displayedProductsListStateController = 
  BehaviorSubject<List<Product>>();
  StreamSink<List<Product>> get _inDisplayedProducts => _displayedProductsListStateController.sink;
  Stream<List<Product>> get outDisplayedProducts => _displayedProductsListStateController.stream;

  BehaviorSubject<int> _productSelectedIndexStateController = 
  BehaviorSubject<int>();
  StreamSink<int> get inSelectedIndex => _productSelectedIndexStateController.sink;
  Stream<int> get selectedIndex => _productSelectedIndexStateController.stream;


  final _productQueryEventController = BehaviorSubject<ProductsQueryEvent>();
  StreamSink<ProductsQueryEvent> get productQueryEventSink => _productQueryEventController.sink;

  ProductsBloc()
  {
    products.listen((_){
      var displayedProds = _products.where((prod) => !_isFavouriteList || prod.isFavourite).toList();
      _inDisplayedProducts.add(displayedProds);
      displayedProds.

    });
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
    } else if(event is ToggleDisplayedItems){
      _isFavouriteList = !_isFavouriteList;
      _inProducts.add(_products); // just to trigger displayedProducts
    }
    else if(event is ToggleItemFavouriteProperty){
      _products[event.index] = event.isFavourite != _products[event.index].isFavourite
      ?_products[event.index].toggleFavourite(): _products[event.index];
      _inProducts.add(_products);
    }
    else if (event is FormSubmitEvent) {
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
    _displayedProductsListStateController.close();
  }
}