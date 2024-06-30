// To parse this JSON data, do
//
//     final foodTruck = foodTruckFromJson(jsonString);

import 'package:app/app/truck_feature/domain/entities/menu/menu.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

FoodTruckMenuModel foodTruckMenuFromJson(String str) =>
    FoodTruckMenuModel.fromJson(json.decode(str));

class FoodTruckMenuModel extends FoodTruckMenu {
  FoodTruckMenuModel({
    required super.categories,
  });

  factory FoodTruckMenuModel.fromJson(Map<String, dynamic> json) =>
      FoodTruckMenuModel(
        categories: List<CategoryModel>.from(
            json["categories"].map((x) => CategoryModel.fromJson(x))),
      );
}

class CategoryModel extends Category {
  CategoryModel({
    required super.name,
    required super.items,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        items: List<Item>.from(json["items"].map((x) => ItemModel.fromJson(x))),
      );
}

class ItemModel extends Item {
  ItemModel({
    required super.title,
    required super.price,
    required super.description,
    required super.image,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        title: json["title"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "description": description,
        "image": image,
      };
}
