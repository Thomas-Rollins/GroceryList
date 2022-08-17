import 'package:cloud_firestore/cloud_firestore.dart';

class ListModel {
  final String id;
  final String? name;
  final bool? isFavourite;
  final bool? isSelected;
  final int? index;
  final Timestamp? lastUpdated;

  ListModel({
    required this.id,
    this.name,
    this.isFavourite,
    this.isSelected,
    this.index,
    this.lastUpdated,
  });

  Timestamp get curTime => Timestamp.now();

  //temp placeholder
  double get total => getTotalFromItems();

  //serialization
  factory ListModel.fromMap(Map<String, dynamic> data, String documentId) {
    final String? name = data['name'];
    final int? index = data['index'];
    final bool? isSelected = data['isSelected'];
    final bool? isFavourite = data['isFavourite'];
    final Timestamp? lastUpdated = data['lastUpdated'];

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
    }..removeWhere((key, value) => value == null);
  }
}
