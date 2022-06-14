import 'package:cloud_firestore/cloud_firestore.dart';

class GroceryItemModel {
  String id;
  String name;
  int quantity;
  String brand;
  double costPerItem;
  bool isFavourite;
  bool isSelected;
  int index;
  Timestamp lastUpdated;
  Timestamp dateAdded;
  String category;

  //update to use nullsafe getters?
  GroceryItemModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.brand,
    required this.costPerItem,
    required this.category,
    required this.isFavourite,
    required this.isSelected,
    required this.index,
    required this.lastUpdated,
    required this.dateAdded,
  });

  // serialization
  factory GroceryItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String name = data['name'];
    int quantity = data['quantity'];
    String brand = data['brand'] ?? '';
    double costPerItem = data['cost'] ?? 0.00;
    String category = data['category'] ?? 'Unset';
    bool isFavourite = data['isFavourite'] ?? false;
    bool isSelected = data['isSelected'] ?? false;
    int index = data['index'];
    // may not need to be required?
    Timestamp lastUpdated = data['lastUpdated'];
    Timestamp dateAdded = data['dateAdded'];

    return GroceryItemModel(
        id: documentId,
        name: name,
        quantity: quantity,
        brand: brand,
        costPerItem: costPerItem,
        isFavourite: isFavourite,
        category: category,
        isSelected: isSelected,
        index: index,
        lastUpdated: lastUpdated,
        dateAdded: dateAdded);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'brand': brand,
      'costPerItem': costPerItem,
      'category': category,
      'isFavourite': isFavourite,
      'isSelected': isSelected,
      'index': index,
      'lastUpdated': lastUpdated,
      'dateAdded': dateAdded
    };
  }
}
