import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list/models/list_item_model.dart';
import 'package:grocery_list/models/user_item_model.dart';

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

  Timestamp get curTime => Timestamp.now();

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
