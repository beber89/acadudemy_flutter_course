import 'package:acadudemy_flutter_course/models/product.dart';

abstract class ProductsQueryEvent {}

class DeleteEvent extends ProductsQueryEvent {
  final int _index;
  int get index => _index;
  DeleteEvent(this._index);
}

class CreateEvent extends ProductsQueryEvent {
  final Product _product;
  Product get product => _product;
  CreateEvent(this._product);
}

class UpdateEvent extends ProductsQueryEvent {
  final int _index;
  final Product _editedProduct;

  int get index => _index;
  Product get updatedProduct => _editedProduct;
  UpdateEvent(this._index, this._editedProduct);
}