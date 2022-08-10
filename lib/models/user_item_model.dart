import 'package:cloud_firestore/cloud_firestore.dart';

class UserItemModel {
  String id;
  String? name;
  String? brand;
  String? category;
  double? costPerItem;
  bool? isFavourite;
  Timestamp? dateAdded;
  Timestamp? lastUpdated;

  UserItemModel({
    required this.id,
    this.name,
    this.brand,
    this.category,
    this.costPerItem,
    this.isFavourite,
    this.dateAdded,
    this.lastUpdated,
  });

  // serialization
  factory UserItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String id = documentId;
    String? name = data['name'];
    String? brand = data['brand'];
    double? costPerItem = data['cost'];
    String? category = data['category'];
    bool? isFavourite = data['isFavourite'];
    Timestamp? lastUpdated = data['lastUpdated'];
    Timestamp? dateAdded = data['dateAdded'];

    return UserItemModel(
      id: id,
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
    }..removeWhere((key, value) => value == null);
  }
}
