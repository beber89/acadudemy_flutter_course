import 'package:acadudemy_flutter_course/models/product.dart';

abstract class ProductsQueryEvent {}

class SelectEvent extends ProductsQueryEvent {
  final int _index;
  int get index => _index;
  SelectEvent(this._index);
}
class FormSubmitEvent extends ProductsQueryEvent {
  final Product _product;
  Product get product => _product;
  FormSubmitEvent(this._product);
}

class DeleteEvent extends ProductsQueryEvent {
  DeleteEvent();
}

class CreateEvent extends ProductsQueryEvent {
  final Product _product;
  Product get product => _product;
  CreateEvent(this._product);
}

class UpdateEvent extends ProductsQueryEvent {
  final Product _editedProduct;
  Product get updatedProduct => _editedProduct;
  UpdateEvent(this._editedProduct);
}