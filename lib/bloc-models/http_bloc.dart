import 'package:acadudemy_flutter_course/models/location_data.dart';
import 'package:http/http.dart' as http;
import 'package:acadudemy_flutter_course/models/product.dart';
import 'dart:convert';
import 'package:acadudemy_flutter_course/models/product.dart';

mixin HttpBloc {
  Future<bool> deleteProduct(String token, String selectedId) {
    return http
        .delete(
            'https://flutter-products-5f0b8.firebaseio.com/products/${selectedId}.json?auth=${token}')
        .then((http.Response response) {
      print(response.statusCode != 200);
      if (response.statusCode != 200 && response.statusCode != 201) {}
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> ensureTokenIsValid(token) {
    return http
        .get(
            'https://flutter-products-5f0b8.firebaseio.com/products.json?auth=${token}')
        .then<bool>((http.Response response) {
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData != null && productListData['error'] == "Auth token is expired") {
        return false;
      }
      return true;
    });
  }

  Future<List<Product>> fetchProducts(token) {
    return http
        .get(
            'https://flutter-products-5f0b8.firebaseio.com/products.json?auth=${token}')
        .then<List<Product>>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        return [];
      }
      if(productListData.containsKey('error')) {
        print("has error");
        throw new Exception('There is an error');
      }
      print(productListData);
      productListData.forEach((String productId, dynamic productData) {
        print(productData['location']['address']);
        LocationData loc = LocationData(
          address: productData['location']['address'],
          latitude:  productData['location']['latitude'],
          longitude: productData['location']['longitude']
        );
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
          location: loc,
        );
        fetchedProductList.add(product);
      });
      return fetchedProductList;
    });
  }

  Future<Product> updateProduct(String token, Product product) {
    final Map<String, dynamic> updateData = {
      'title': product.title,
      'description': product.description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': product.price,
      'location': {
        'address': product.location.address,
        'latitude': product.location.latitude,
        'longitude': product.location.longitude
        } ,
      'userEmail': product.userEmail,
      'userId': product.userId,
      'isFavourite': product.isFavourite
    };
    return http
        .put(
            'https://flutter-products-5f0b8.firebaseio.com/products/${product.id}.json?auth=${token}',
            body: json.encode(updateData))
        .then((http.Response reponse) {
      final Product updatedProduct = Product(
        id: product.id,
      title: product.title,
      description: product.description,
      image: product.image,
      price: product.price,
      location: product.location,
      userEmail: product.userEmail,
      userId: product.userId,
      isFavourite: product.isFavourite
      );
      return updatedProduct;
    }).catchError((error) {
      return null;
    });
  }

  Future<Product> addProduct(String token, Product product) async {
    final Map<String, dynamic> productData = {
      'title': product.title,
      'description': product.description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': product.price,
      'userEmail': product.userEmail,
      'userId': product.userId,
      'location': {
        'address': product.location.address,
        'latitude': product.location.latitude,
        'longitude': product.location.longitude
        } ,
      'isFavourite': product.isFavourite
    };
    print("before tying ..");
    print(json.encode(productData));
    try {
      final http.Response response = await http.post(
          'https://flutter-products-5f0b8.firebaseio.com/products.json?auth=${token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
        id: responseData['name'],
        title: product.title,
        description: product.description,
        image: product.image,
        price: product.price,
        userEmail: product.userEmail,
        userId: product.userId,
        location: product.location,
      );
      return newProduct;
    } catch (error) {
      return null;
    }
  }
}
