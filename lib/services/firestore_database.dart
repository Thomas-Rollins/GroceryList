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
    print("Delete UID: $uid");
    await _firestoreService.deleteData(path: FirestorePath.groceryList(uid, list.id));
  }

  // retrieve listModel based on the given listId
  Stream<ListModel> listStream({required String listId}) =>
      _firestoreService.documentStream(
        path: FirestorePath.groceryList(uid, listId),
        builder: (data, documentId) => ListModel.fromMap(data, documentId),
      );

  // retrieve all lists from the same user based on uid
  Stream<List<ListModel>> listsStream() => _firestoreService.collectionStream(
    path: FirestorePath.lists(uid),
    builder: (data, documentId) => ListModel.fromMap(data, documentId),
  );

}