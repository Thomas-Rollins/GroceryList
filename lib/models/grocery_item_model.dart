import 'package:cloud_firestore/cloud_firestore.dart';

class ListItemModel {
  String id;
  int? index;
  bool? isSelected;
  int? quantity;
  double? salePricePerItem;
  Timestamp? dateAddedToList;

  ListItemModel({
    required this.id,
    this.index,
    this.isSelected,
    this.quantity,
    this.salePricePerItem,
    this.dateAddedToList,
  });

  // serialization
  factory ListItemModel.fromMap(Map<String, dynamic> data, String documentId) {
    String id = data['id'];
    int? quantity = data['quantity'];
    double? salePricePerItem = data['salePrice'];
    bool? isSelected = data['isSelected'];
    int? index = data['index'];
    Timestamp? dateAdded = data['dateAddedToList'];

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
    }..removeWhere((key, value) => value == null);
  }
}

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

class GroceryItemModel {
  final ListItemModel groceryListItem;
  final UserItemModel userItem;

  String get id => groceryListItem.id;
  String get name => userItem.name ?? '(Unnamed)';
  String get brand => userItem.brand ?? '(unset)';
  String get category => userItem.category ?? '(unset)';

  int get index => groceryListItem.index ?? -1;
  int get quantity => groceryListItem.quantity ?? 1;

  double get costPerItem => userItem.costPerItem ?? 0.00;
  double get salePricePerItem => groceryListItem.salePricePerItem ?? 0.00;

  bool get isSelected => groceryListItem.isSelected ?? false;
  bool get isFavourite => userItem.isFavourite ?? false;

  Timestamp get dateAdded => groceryListItem.dateAddedToList ?? Timestamp(0, 0);
  Timestamp get dateCreated => userItem.dateAdded ?? Timestamp(0, 0);
  Timestamp get lastUpdated => userItem.lastUpdated ?? Timestamp(0, 0);

  GroceryItemModel({
    required this.groceryListItem,
    required this.userItem,
  });

  factory GroceryItemModel.fromMap(Map<String, dynamic> data, String itemId) {
    String name = data['name'];
    String brand = data['brand'];
    double costPerItem = data['cost'];
    String category = data['category'];
    bool isFavourite = data['isFavourite'];
    Timestamp lastUpdated = data['lastUpdated'];
    Timestamp dateAdded = data['dateAdded'];
    int quantity = data['quantity'];
    double salePricePerItem = data['salePrice'];
    bool isSelected = data['isSelected'];
    int? index = data['index'];
    Timestamp dateAddedToList = data['dateAddedToList'];

    ListItemModel newListItem = ListItemModel(
      id: itemId,
      quantity: quantity,
      salePricePerItem: salePricePerItem,
      isSelected: isSelected,
      index: index,
      dateAddedToList: dateAdded,
    );

    UserItemModel newUserItem = UserItemModel(
      id: itemId,
      name: name,
      brand: brand,
      costPerItem: costPerItem,
      isFavourite: isFavourite,
      category: category,
      lastUpdated: lastUpdated,
      dateAdded: dateAddedToList,
    );

    return GroceryItemModel(groceryListItem: newListItem, userItem: newUserItem);
  }

  Map<String, dynamic> toMap() {
    assert(groceryListItem.id == userItem.id);
    return {
      ...groceryListItem.toMap(),
      ...userItem.toMap(),
    }..removeWhere((key, value) => value == null);
  }
}
