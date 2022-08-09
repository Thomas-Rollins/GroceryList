import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/models/grocery_item_model.dart';
import 'package:grocery_list/providers/auth_provider.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:grocery_list/ui/list/empty_content.dart';
import 'package:grocery_list/ui/shared/favourite_star.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemsScreen extends StatelessWidget {
  final String listId;

  const ItemsScreen({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);


    return _buildBodySection(context, authProvider, listId);
  }

  List<Widget> _buildListItems(context, items, firestoreDatabase, authProvider) {
    List<Widget> tiles = [];

    for(int index = 0; index < items.length; index++) {
      final String formattedDate = DateFormat('yMd').add_Hm().format(items[index].lastUpdated.toDate());
      tiles.add(
        Card(
          key: Key('$listId/${items[index].id}'),
          margin: const EdgeInsets.all(8),
          color: Theme.of(context).cardColor,
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: Text(items[index].name)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 8),
                          child: Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Slidable(
                endActionPane: ActionPane(
                  dragDismissible: false,
                  // take up the entire child space
                  extentRatio: 1.0,
                  // drag 3/4 to open
                  openThreshold: 0.75,
                  // drag 1/2 to close
                  closeThreshold: 0.5,
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                        autoClose: true,
                        spacing: 8,
                        onPressed: (BuildContext context) {
                          if(kDebugMode) {
                            print("Deleted ${items[index].name}");
                          }
                          //firestoreDatabase.deleteList(lists[index].id);
                        },
                        backgroundColor: Colors.red,
                        label: 'Delete',
                        icon: Icons.delete),
                  ],
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: GestureDetector(
                        child: FavouriteStar(isFavourite: items[index].isFavourite),
                        onTap: () => {
                          // _updateFavourite(lists[index], firestoreDatabase),
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return tiles;

  }

  Widget _buildBodySection(BuildContext context, authProvider, listId) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
        stream: firestoreDatabase.groceryItemStream(listId: listId),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            List<dynamic> data = snapshot.data as List;

            List listItems = data[1] as List<ListItemModel>;
            List userItems = data[0] as List<UserItemModel>;
            List<GroceryItemModel> items = [];

            for(int i = 0; i < min(listItems.length, userItems.length); i++){
              final GroceryItemModel groceryItem = GroceryItemModel(
                  groceryListItem: listItems[i],
                  userItem: userItems[i],
              );
              items.add(groceryItem);
            }

            if (items.isNotEmpty) {
              items.sort((a, b) => a.index.compareTo(b.index));
              return ReorderableListView(
                children: _buildListItems(context, items, firestoreDatabase, authProvider),
                onReorder: (int oldIndex, int newIndex) {
                  // if (oldIndex < newIndex) {
                  //   newIndex--;
                  // }
                  // // set old index to new
                  // // _setOrder(items[oldIndex], newIndex, firestoreDatabase);
                  //
                  // // iterate over list and adjust the rest of the indices
                  // if (oldIndex < newIndex) {
                  //   for (int i = newIndex; i > oldIndex; i--) {
                  //     // _setOrder(items[i], items[i].index - 1, firestoreDatabase);
                  //   }
                  // } else {
                  //   for (int i = newIndex; i < oldIndex; i++) {
                  //     // _setOrder(items[i], items[i].index + 1, firestoreDatabase);
                  //   }
                  // }
                },
              );
            } else {
              return EmptyContentWidget(
                title: AppLocalizations.of(context).translate("todosEmptyTopMsgDefaultTxt"),
                message: AppLocalizations.of(context).translate("todosEmptyBottomDefaultMsgTxt"),
                key: const Key('EmptyContentWidget'),
              );
            }
          } else if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  // void _setOrder(GroceryItemModel item, int newIndex, firestoreDatabase) {
  //   GroceryItemModel newList = GroceryItemModel(
  //     id: list.id,
  //     index: newIndex,
  //     name: list.name,
  //     isFavourite: list.isFavourite,
  //     isSelected: list.isSelected,
  //     lastUpdated: list.lastUpdated,
  //   );

  //   firestoreDatabase.setList(newList);
  // }
}
