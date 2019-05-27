import 'package:http/http.dart' as http;
import 'package:acadudemy_flutter_course/models/product.dart';
import 'dart:convert';

mixin HttpBloc {
  Future<bool> deleteProduct(String token, String selectedId) {
    return http
        .delete(
            'https://flutter-products-5f0b8.firebaseio.com/products/${selectedId}.json?auth=${token}')
        .then((http.Response response) {
          print(response.statusCode != 200);
      if (response.statusCode != 200 && response.statusCode != 201) {
      }
      return true;
    }).catchError((error) {
      return false;
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
        return null;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
        );
        fetchedProductList.add(product);
      });
      return fetchedProductList;
    });
  }

  Future<Product> updateProduct(String token, String selectedId, String title,
      String description, String image, double price) {
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': price,
    };
    return http
        .put(
            'https://flutter-products-5f0b8.firebaseio.com/products/${selectedId}.json?auth=${token}',
            body: json.encode(updateData))
        .then((http.Response reponse) {
      final Product updatedProduct = Product(
        id: selectedId,
        title: title,
        description: description,
        image: image,
        price: price,
      );
      return updatedProduct;
    }).catchError((error) {
      return null;
    });
  }

  Future<Product> addProduct(String token, String title, String description,
      String image, double price) async {
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'price': price,
    };
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
        title: title,
        description: description,
        image: image,
        price: price,
      );
      return newProduct;
    } catch (error) {
      return null;
    }
  }
}
