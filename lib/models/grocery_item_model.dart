import 'package:cloud_firestore/cloud_firestore.dart';

class ListItemModel {
  String id;
  int index;
  bool isSelected;
  int quantity;
  double salePricePerItem;
  Timestamp dateAddedToList;

  ListItemModel({
    required this.id,
    required this.index,
    required this.isSelected,
    required this.quantity,
    required this.salePricePerItem,
    required this.dateAddedToList,
  });

  // serialization
  factory ListItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String id = data['id'];
    int quantity = data['quantity'];
    double salePricePerItem = data['salePrice'] ?? 0.00;
    bool isSelected = data['isSelected'] ?? false;
    int index = data['index'];
    // may not need to be required?
    Timestamp dateAdded = data['dateAddedToList'];

    return ListItemModel(
      id: id,
      quantity: quantity,
      salePricePerItem: salePricePerItem,
      isSelected: isSelected,
      index: index,
      dateAddedToList: dateAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantity': quantity,
      'salePricePerItem': salePricePerItem,
      'isSelected': isSelected,
      'index': index,
      'dateAddedToList': dateAddedToList
    };
  }
}

class UserItemModel {
  String name;
  String brand;
  String category;
  String id;
  double costPerItem;
  bool isFavourite;
  Timestamp dateAdded;
  Timestamp lastUpdated;

  UserItemModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.costPerItem,
    required this.isFavourite,
    required this.dateAdded,
    required this.lastUpdated,
  });

  // serialization
  factory UserItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String name = data['name'];
    String brand = data['brand'] ?? '';
    double costPerItem = data['cost'] ?? 0.00;
    String category = data['category'] ?? 'Unset';
    bool isFavourite = data['isFavourite'] ?? false;
    // may not need to be required?
    Timestamp lastUpdated = data['lastUpdated'];
    Timestamp dateAdded = data['dateAdded'];

    return UserItemModel(
      id: documentId,
      name: name,
      brand: brand,
      costPerItem: costPerItem,
      isFavourite: isFavourite,
      category: category,
      lastUpdated: lastUpdated,
      dateAdded: dateAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'costPerItem': costPerItem,
      'category': category,
      'isFavourite': isFavourite,
      'lastUpdated': lastUpdated,
      'dateAdded': dateAdded
    };
  }
}

class GroceryItemModel {
  final ListItemModel groceryListItem;
  final UserItemModel userItem;

  String get id => groceryListItem.id;
  String get name => userItem.name;
  String get brand => userItem.brand;
  String get category => userItem.category;

  int get index => groceryListItem.index;
  int get quantity => groceryListItem.quantity;

  double get costPerItem => userItem.costPerItem;
  double get salePricePerItem => groceryListItem.salePricePerItem;

  bool get isSelected => groceryListItem.isSelected;
  bool get isFavourite => userItem.isFavourite;

  Timestamp get dateAdded => groceryListItem.dateAddedToList;
  Timestamp get dateCreated => userItem.dateAdded;
  Timestamp get lastUpdated => userItem.lastUpdated;

  GroceryItemModel({
    required this.groceryListItem,
    required this.userItem,
  });

  // factory GroceryItemModel.fromMap(Map<String, dynamic> userItem, Map<String, dynamic> listItem){
  //   return {
  //     ...userItem,
  //     ...listItem,
  //   };
  // }

  Map<String, dynamic> toMap() {
    return {
      ...groceryListItem.toMap(),
      ...userItem.toMap(),
    };
  }
}

// String id;
// String name;
// int quantity;
// String brand;
// double costPerItem;
// double salePricePerItem;
// bool isFavourite;
// bool isSelected;
// int index;
// Timestamp lastUpdated;
// Timestamp dateAdded;
// String category;
//
// //update to use nullsafe getters?
// GroceryItemModel({
//   required this.id,
//   required this.name,
//   required this.quantity,
//   required this.brand,
//   required this.costPerItem,
//   required this.salePricePerItem,
//   required this.category,
//   required this.isFavourite,
//   required this.isSelected,
//   required this.index,
//   required this.lastUpdated,
//   required this.dateAdded,
// });
//
// // serialization
// factory GroceryItemModel.fromMap(Map<String, dynamic> data, String documentId) {
//   String name = data['name'];
//   int quantity = data['quantity'];
//   String brand = data['brand'] ?? '';
//   double costPerItem = data['cost'] ?? 0.00;
//   double salePricePerItem = data['salePrice'] ?? 0.00;
//   String category = data['category'] ?? 'Unset';
//   bool isFavourite = data['isFavourite'] ?? false;
//   bool isSelected = data['isSelected'] ?? false;
//   int index = data['index'];
//   // may not need to be required?
//   Timestamp lastUpdated = data['lastUpdated'];
//   Timestamp dateAdded = data['dateAdded'];
//
//   return GroceryItemModel(
//     id: documentId,
//     name: name,
//     quantity: quantity,
//     brand: brand,
//     costPerItem: costPerItem,
//     salePricePerItem: salePricePerItem,
//     isFavourite: isFavourite,
//     category: category,
//     isSelected: isSelected,
//     index: index,
//     lastUpdated: lastUpdated,
//     dateAdded: dateAdded,
//   );
// }
//
// Map<String, dynamic> toMap() {
//   return {
//     'id': id,
//     'name': name,
//     'quantity': quantity,
//     'brand': brand,
//     'costPerItem': costPerItem,
//     'salePricePerItem': salePricePerItem,
//     'category': category,
//     'isFavourite': isFavourite,
//     'isSelected': isSelected,
//     'index': index,
//     'lastUpdated': lastUpdated,
//     'dateAdded': dateAdded
//   };
// }
// }
