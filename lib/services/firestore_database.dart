import 'package:flutter/foundation.dart';
import 'package:grocery_list/models/grocery_item_model.dart';
import 'package:grocery_list/models/list_model.dart';
import 'package:grocery_list/services/firestore_path.dart';
import 'package:grocery_list/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid});
  final String uid;

  final _firestoreService = FirestoreService.instance;

  // create/update listModel
  Future<void> setList(ListModel list) async => await _firestoreService.set(
        path: FirestorePath.groceryList(uid, list.id),
        data: list.toMap(),
      );

  // delete list entry
  Future<void> deleteList(ListModel list) async {
    if (kDebugMode) {
      print("Delete UID: $uid");
    }
    await _firestoreService.deleteData(path: FirestorePath.groceryList(uid, list.id));
  }

  // retrieve listModel based on the given listId
  Stream listStream({required String listId}) {
    print(_firestoreService);
    Stream list = _firestoreService.documentStream(
      path: FirestorePath.groceryList(uid, listId),
      builder: (data, documentId) => ListModel.fromMap(data, documentId),
    );

    return _firestoreService.mergeStreams(streams: [list]);
  }

  // retrieve all lists from the same user based on uid
  Stream<List<ListModel>> listsStream() => _firestoreService.collectionStream(
        path: FirestorePath.lists(uid),
        builder: (data, documentId) => ListModel.fromMap(data, documentId),
      );

  // retrieve list item
  Stream listItemStream({required String listId, required String itemId}) => _firestoreService.documentStream(
        path: FirestorePath.listItemDetails(uid, listId, itemId),
        builder: (data, documentId) => ListItemModel.fromMap(data, documentId),
      );

  // retrieve all list items
  Stream<List<ListItemModel>> listItemsStream({required String listId}) => _firestoreService.collectionStream(
        path: FirestorePath.listItems(uid, listId),
        builder: (data, documentId) => ListItemModel.fromMap(data, documentId),
      );

  // retrieve user item
  Stream userItemStream({required String listId, required String itemId}) => _firestoreService.documentStream(
        path: FirestorePath.item(uid, itemId),
        builder: (data, documentId) => UserItemModel.fromMap(data, documentId),
      );

  // retrieve all user items
  Stream<List<UserItemModel>> userItemsStream({required String listId}) => _firestoreService.collectionStream(
        path: FirestorePath.items(uid),
        builder: (data, documentId) => UserItemModel.fromMap(data, documentId),
      );

  // retrieve all item data for list

  Stream<List> groceryItemStream({required String listId}) => _firestoreService.mergeStreams(streams: [
        userItemsStream(listId: listId),
        listItemsStream(listId: listId),
      ]);
}
// a0eZOHBMtzU12V98Neudb8ohLPS2
