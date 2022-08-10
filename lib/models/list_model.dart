import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  final String id;
  final String name;
  final bool isFavourite;
  final bool isSelected;
  final int index;
  final Timestamp? lastUpdated;
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
  double get total => getTotalFromItems();

  //serialization
  factory ListModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final int index = data['index'];
    final bool isSelected = data['isSelected'] ?? false;
    final bool isFavourite = data['isFavourite'] ?? false;
    final Timestamp lastUpdated = data['lastUpdated'] ?? Timestamp.now();

    ListModel newList = ListModel(
      id: documentId,
      index: index,
      name: name,
      isSelected: isSelected,
      isFavourite: isFavourite,
      lastUpdated: lastUpdated,
    );
    return newList;
  }

  double getTotalFromItems() {
    double listTotal = 0.00;
    // for(ListItemModel item in items) {
    //   listTotal += (item.costPerItem * item.quantity);
    // }

    return listTotal;
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
