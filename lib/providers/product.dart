import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_flutter_app/models/http_exception.dart';

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  String creatorId;
  bool isFavourite;

  Product({this.id, this.title, this.description, this.price, this.imageUrl, this.isFavourite = false, this.creatorId});

  Future<void> toggleFavouriteStatus(String authToken, String userId) async {
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      var response = await http.put('https://flutter-shop-3798e.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken', body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        throw HttpException('Could not update favourite status');
      }
    } catch(error) {
      isFavourite = !isFavourite;
      notifyListeners();
      throw HttpException('Could not update favourite status');
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavourite: $isFavourite}';
  }

  Map<String, dynamic> get toJson {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavourite': isFavourite,
      'creatorId': creatorId,
    };
  }

}