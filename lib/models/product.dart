import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavourite;
  
  Product toggleFavourite() {
    return Product(
      title: title,
      description: description,
      price: price,
      image: image,
      isFavourite: !isFavourite,
    );
  }

  Product(
      {
        @required this.id,
        @required this.title,
        @required this.description,
        @required this.price,
        @required this.image,
        this.isFavourite = false
      });
}
