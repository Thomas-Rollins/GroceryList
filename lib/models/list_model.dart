import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list/models/grocery_item_model.dart';

class ListModel{
  final String id;
  final String name;
  final bool isFavourite;
  final bool isSelected;
  final int index;
  final Timestamp? lastUpdated;
  List<GroceryItemModel> _items = [];
  UnmodifiableListView<GroceryItemModel> get items => UnmodifiableListView(_items);
  Timestamp get curTime => Timestamp.now();

  ListModel({
    required this.id,
    required this.name,
    required this.isFavourite,
    required this.isSelected,
    required this.index,
    this.lastUpdated,
  });

  //temp placeholder
  double get total => 10.42;

  //serialization
  factory ListModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final int index = data['index'];
    final bool isSelected = data['isSelected'] ?? false;
    final bool isFavourite = data['isFavourite'] ?? false;
    final Timestamp lastUpdated = data['lastUpdated'] ?? Timestamp.now();
    final List<GroceryItemModel> items = data['items'] ?? [];

    ListModel newList = ListModel(
      id: documentId,
      index: index,
      name: name,
      isSelected: isSelected,
      isFavourite: isFavourite,
      lastUpdated: lastUpdated,
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
      'lastUpdated': lastUpdated,
    };
  }

}