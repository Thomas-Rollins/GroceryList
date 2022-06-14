import 'dart:collection';

import 'package:grocery_list/models/grocery_item_model.dart';

class ListModel{
  final String id;
  final String name;
  final bool isFavourite;
  final bool isSelected;
  int index;
  List<GroceryItemModel> _items = [];
  UnmodifiableListView<GroceryItemModel> get items => UnmodifiableListView(_items);

  ListModel({
    required this.id,
    required this.name,
    required this.isFavourite,
    required this.isSelected,
    required this.index,
  });

  double get total => 10.4;

  //serialization
  factory ListModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final int index = data['index'];
    final bool isSelected = data['isSelected'] ?? false;
    final bool isFavourite = data['isFavourite'] ?? false;
    final List<GroceryItemModel> items = data['items'] ?? [];

    ListModel newList = ListModel(
      id: documentId,
      index: index,
      name: name,
      isSelected: isSelected,
      isFavourite: isFavourite
    );

    newList._items = items;
    return newList;
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'index': index,
      'name': name,
      'isSelected': isSelected,
      'isFavourite': isFavourite,
    };
  }

}