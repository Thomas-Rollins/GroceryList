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

  Timestamp get curTime => Timestamp.now();

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
