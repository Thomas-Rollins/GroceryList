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
  Future<void> setList(ListModel list) async {
    try {
      await _firestoreService.set(
        path: FirestorePath.groceryList(uid, list.id),
        data: list.toMap(),
      );
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // create/update ListItemModel
  Future<void> setListItem(ListItemModel listItem, String listId) async {
    try {
      await _firestoreService.set(
        path: FirestorePath.listItemDetails(uid, listId, listItem.id),
        data: listItem.toMap(),
      );
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // create/update UserItemModel
  Future<void> setUserItem(UserItemModel userItem, String listId) async {
    try {
      await _firestoreService.set(
        path: FirestorePath.item(uid, userItem.id),
        data: userItem.toMap(),
      );
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  // create/update GroceryItemModel
  Future<void> setGroceryItem(GroceryItemModel groceryItem, String listId) async {
    // update iff more than the id is provided.
    if (groceryItem.userItem.toMap().keys.length > 1) {
      if (groceryItem.groceryListItem.toMap().keys.length == 1) {
        try {
          await setUserItem(groceryItem.userItem, listId);
        } catch (err) {
          if (kDebugMode) {
            print(err);
          }
        }
        // both models need to be updated
      } else {
        try {
          await Future.wait(
            [
              setUserItem(groceryItem.userItem, listId),
              setListItem(groceryItem.groceryListItem, listId),
            ],
          );
        } catch (err) {
          if (kDebugMode) {
            print(err);
          }
        }
      }
      // only one model needs updated
    } else if (groceryItem.groceryListItem.toMap().keys.length > 1) {
      try {
        await setListItem(
          groceryItem.groceryListItem,
          listId,
        );
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }
  }

  // delete list entry
  Future<void> deleteList(ListModel list) async {
    try {
      await _firestoreService.deleteData(path: FirestorePath.groceryList(uid, list.id));
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
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
