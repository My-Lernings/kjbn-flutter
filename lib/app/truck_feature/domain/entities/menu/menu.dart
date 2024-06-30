import 'package:equatable/equatable.dart';

class FoodTruckMenu extends Equatable {
  final List<Category> categories;

  FoodTruckMenu({
    required this.categories,
  });

  @override
  List<Object?> get props => [];
}

class Category extends Equatable {
  final String name;
  final List<Item> items;

  Category({
    required this.name,
    required this.items,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Item extends Equatable {
  final String title;
  final double price;
  final String description;
  final String image;

  Item({
    required this.title,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
