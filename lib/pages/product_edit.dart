import 'package:flutter/material.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../models/product.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_query_event.dart';
import 'package:acadudemy_flutter_course/bloc-models/products_bloc.dart';
import 'package:provider/provider.dart';

class ProductEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image':
        'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  ProductsBloc bloc;
  

  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        focusNode: _titleFocusNode,
        decoration: InputDecoration(labelText: 'Product Title'),
        initialValue: product == null ? '' : product.title,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long.';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(labelText: 'Product Description'),
        initialValue: product == null ? '' : product.description,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long.';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Product Price'),
        initialValue: product == null ? '' : product.price.toString(),
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Price is required and should be a number.';
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
      ),
    );
  }

  Widget _buildSubmitButton(context) {
    return StreamBuilder(
        stream: bloc.selectedId,
        builder: (context, snapshot) => RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              onPressed: () {
                _submitForm(snapshot.data);
              },
            ));
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(String selectedId) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedId == null) {
      bloc.productQueryEventSink.add(FormSubmitEvent(
        Product(
            id: "",
            title: _formData['title'],
            description: _formData['description'],
            price: _formData['price'],
            image: _formData['image']),
      ));
    } else {
      bloc.productQueryEventSink.add(UpdateEvent(
        Product(
            id: "",
            title: _formData['title'],
            description: _formData['description'],
            price: _formData['price'],
            image: _formData['image']),
      ));
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ProductsBloc>(context);
    return StreamBuilder<List<Product>>(
        stream: Provider.of<ProductsBloc>(context).products,
        builder:
            (BuildContext context, AsyncSnapshot<List<Product>> prodsSnapshot) {
          return StreamBuilder<String>(
              stream: Provider.of<ProductsBloc>(context).selectedId,
              builder:
                  (BuildContext context, AsyncSnapshot<String> idSnapshot) {
                    // print("snapeshot "+idSnapshot.data);
                    //FIXME:
                    if(idSnapshot.data != null)
                    {print(prodsSnapshot.data
                                .where((prod) => idSnapshot.data == prod.id)
                                .first);}
                return idSnapshot.data == null
                    ? _buildPageContent(context, null)
                    : Scaffold(
                        appBar: AppBar(
                          title: Text('Edit Product'),
                        ),
                        body: _buildPageContent(
                            context,
                            prodsSnapshot.data
                                .where((prod) => idSnapshot.data == prod.id)
                                .first
                            ),
                      );
              });
        });
  }
}
