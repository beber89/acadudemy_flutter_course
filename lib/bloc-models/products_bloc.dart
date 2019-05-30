import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/models/product.dart';
import 'package:rxdart/rxdart.dart';
import 'http_bloc.dart';

import "dart:async";

class ProductsBloc with HttpBloc {
  List<Product> _products = [];
  int _selectedIndex;
  String _selectedId;
  bool _isFavouriteList = false;
  String _token;

  var _productsListStateController = BehaviorSubject<List<Product>>();
  StreamSink<List<Product>> get _inProducts =>
      _productsListStateController.sink;
  Stream<List<Product>> get products => _productsListStateController.stream;

  BehaviorSubject<List<Product>> _displayedProductsListStateController =
      BehaviorSubject<List<Product>>();
  StreamSink<List<Product>> get _inDisplayedProducts =>
      _displayedProductsListStateController.sink;
  Stream<List<Product>> get outDisplayedProducts =>
      _displayedProductsListStateController.stream;

  BehaviorSubject<int> _productSelectedIndexStateController =
      BehaviorSubject<int>();
  StreamSink<int> get inSelectedIndex =>
      _productSelectedIndexStateController.sink;
  Stream<int> get selectedIndex => _productSelectedIndexStateController.stream;

  BehaviorSubject<String> _productSelectedIdStateController =
      BehaviorSubject<String>();
  StreamSink<String> get inSelectedId => _productSelectedIdStateController.sink;
  Stream<String> get selectedId => _productSelectedIdStateController.stream;

  final _productQueryEventController = BehaviorSubject<ProductsQueryEvent>();
  StreamSink<ProductsQueryEvent> get productQueryEventSink =>
      _productQueryEventController.sink;

  var _uiLoadStateController = BehaviorSubject<bool>();
  StreamSink<bool> get _uiLoadSink =>
      _uiLoadStateController.sink;
  Stream<bool> get uiLoadStream => _uiLoadStateController.stream;

  ProductsBloc() {
    _selectedId = null;
    inSelectedId.add(_selectedId);
    products.listen((prods) {
      var displayedProds =
          prods.where((prod) => !_isFavouriteList || prod.isFavourite).toList();
      _inDisplayedProducts.add(displayedProds);
    });
    _productQueryEventController.stream.listen(_mapEventToState);
  }

  Future<Map<String, String>> assignToken(newToken) {
    _token = newToken;
    if(newToken != null) {
        return fetchProductsFromServer();
    }
    return Future.value(null);
  }

  Future<Map<String, String>> fetchProductsFromServer() {
    return fetchProducts(_token).then<Map<String, String>>((prods) {
      _products = prods;
      _inProducts.add(prods);
      return({'success': 'operation success'});
    }).catchError((e) {return {'error': 'TOKEN_EXPIRED'};});
  }

  void _mapEventToState(ProductsQueryEvent event) {
    if (event is ToggleDisplayedItems) {
      _isFavouriteList = !_isFavouriteList;
      _inProducts.add(_products); // just to trigger displayedProducts
    } else if (event is ToggleItemFavouriteProperty) {
      _products[event.index] =
          event.isFavourite != _products[event.index].isFavourite
              ? _products[event.index].toggleFavourite()
              : _products[event.index];
      _inProducts.add(_products);
    } else if (event is FormSubmitEvent) {
      if (_selectedIndex == null) {
        productQueryEventSink.add(CreateEvent(event.product));
      } else {
        productQueryEventSink.add(UpdateEvent(event.product));
        productQueryEventSink.add(SelectEvent(null));
      }
    }
  }

  Future<Product> _updateItem(Product updatedProduct) {
    int idx = _products.indexWhere((prod) => prod.id == _selectedId);
    _uiLoadSink.add(true);
    return updateProduct(
      _token,
            _selectedId,
            updatedProduct.title,
            updatedProduct.description,
            updatedProduct.image,
            updatedProduct.price)
        .then((prod) {
      _products[idx] = prod;
      _inProducts.add(_products);
      return prod;
    }).then((product) {
      _uiLoadSink.add(false);
      return product;
    }).then((product) => product);
  }

  Future<Product> submitItem(Product product) =>
      _selectedId == null ? _createItem(product) : _updateItem(product);

  Future<Product> _createItem(Product product) {
    return addProduct(_token,
            product.title, product.description, product.image, product.price)
        .then((Product newProduct) {
      _products.add(newProduct);
      _inProducts.add(_products);
      return (newProduct);
    });
  }

  Future<String> selectItemWithId(String itemId) {
    _selectedId = itemId;
    selectedId.drain();
    inSelectedId.add(_selectedId);
    return selectedId.first;
  }

  Future<bool> deleteItem() {
    int idx = _products.indexWhere((prod) => prod.id == _selectedId);
    return deleteProduct(_token, _selectedId).then((bool success) {
      _selectedId = null;
      inSelectedId.add(null);
      if (success) {
        _products.removeAt(idx);
        _inProducts.add(_products);
        return true;
      }
      return false;
    });
  }

  void dispose() {
    _productsListStateController.close();
    _productQueryEventController.close();
    _productSelectedIndexStateController.close();
    _displayedProductsListStateController.close();
    _productSelectedIdStateController.close();
    _uiLoadStateController.close();
  }
}
