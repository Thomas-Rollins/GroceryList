import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/models/grocery_item_model.dart';
import 'package:grocery_list/models/list_item_model.dart';
import 'package:grocery_list/models/user_item_model.dart';
import 'package:grocery_list/providers/auth_provider.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:grocery_list/ui/list/empty_content.dart';
import 'package:grocery_list/ui/list/price_text_field.dart';
import 'package:grocery_list/ui/list/quantity_text_field.dart';
import 'package:grocery_list/ui/shared/favourite_star.dart';
import 'package:grocery_list/ui/shared/list_check_box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemsScreen extends StatelessWidget {
  final String listId;

  const ItemsScreen({Key? key, required this.listId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return _buildBodySection(context, authProvider, listId);
  }

  List<Widget> _buildListItems(context, items, firestoreDatabase, authProvider) {
    List<Widget> tiles = [];
    for (int index = 0; index < items.length; index++) {
      final String formattedDate = DateFormat('yMd').add_Hm().format(items[index].lastUpdated.toDate());
      ValueNotifier priceValueNotifier = ValueNotifier(items[index].costPerItem);
      double salePricePerItem = items[index].salePricePerItem;
      tiles.add(
        Card(
          key: Key('$listId/${items[index].id}'),
          margin: const EdgeInsets.all(8),
          color: Theme.of(context).cardColor,
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async => {
                  if (items[index].isSelected == true)
                    {
                      _updateSelected(items[index], !items[index].isSelected, firestoreDatabase),
                    }
                  else
                    {
                      salePricePerItem = await _salePriceModal(context, items[index].id, priceValueNotifier),
                      _updateSalePrice(
                          items[index],
                          salePricePerItem < 0.0 ? items[index].costPerItem : salePricePerItem,
                          !items[index].isSelected,
                          firestoreDatabase)
                    }
                },
                child: ListCheckBox(isSelected: items[index].isSelected),
              ),
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
              QuantityTextField(listId: listId, itemId: items[index].id, quantity: items[index].quantity),
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
                          if (kDebugMode) {
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
                              _updateFavourite(items[index], !items[index].isFavourite, firestoreDatabase),
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

  _salePriceModal(context, String itemId, ValueNotifier priceValueNotifier) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double minHeight = height > width ? height * 0.3 : width * 0.3;
    BuildContext dialogContext;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            insetPadding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: minHeight,
                    child: const Text("SalePricePerItem"),
                  ),
                ),
                PriceTextField(
                  listId: listId,
                  itemId: itemId,
                  priceNotifier: priceValueNotifier,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () => {
                              //update value
                              Navigator.pop(dialogContext, -1.00)
                            },
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () => {
                              //update value
                              if (priceValueNotifier.value >= 0.0)
                                {Navigator.pop(dialogContext, priceValueNotifier.value)}
                            },
                        child: const Text("Update")),
                  ],
                )
              ],
            ),
          );
        }).then((val) {
      return val;
    });
  }

  void _updateSalePrice(GroceryItemModel item, double salePrice, bool isSelected, firestoreDatabase) {
    ListItemModel newListItem = ListItemModel(
      id: item.groceryListItem.id,
      isSelected: isSelected,
      salePricePerItem: salePrice,
    );

    UserItemModel newUserItem = UserItemModel(
      id: item.userItem.id,
      lastUpdated: Timestamp.now(),
    );

    GroceryItemModel newGroceryItem = GroceryItemModel(groceryListItem: newListItem, userItem: newUserItem);
    firestoreDatabase.setGroceryItem(newGroceryItem, listId);
  }

  void _updateSelected(GroceryItemModel item, bool value, firestoreDatabase) {
    UserItemModel newUserItem = UserItemModel(
      id: item.userItem.id,
      lastUpdated: Timestamp.now(),
    );

    ListItemModel newListItem = ListItemModel(
      id: item.groceryListItem.id,
      isSelected: value,
    );

    GroceryItemModel newGroceryItem = GroceryItemModel(groceryListItem: newListItem, userItem: newUserItem);
    firestoreDatabase.setGroceryItem(newGroceryItem, listId);
  }

  void _updateFavourite(GroceryItemModel item, bool value, firestoreDatabase) {
    UserItemModel newUserItem = UserItemModel(
      id: item.userItem.id,
      isFavourite: value,
      lastUpdated: Timestamp.now(),
    );

    ListItemModel newListItem = ListItemModel(
      id: item.groceryListItem.id,
    );

    GroceryItemModel newGroceryItem = GroceryItemModel(groceryListItem: newListItem, userItem: newUserItem);
    firestoreDatabase.setGroceryItem(newGroceryItem, listId);
  }

  void _setOrder(GroceryItemModel item, int newIndex, firestoreDatabase) {
    UserItemModel newUserItem = UserItemModel(
      id: item.userItem.id,
    );

    ListItemModel newListItem = ListItemModel(
      id: item.groceryListItem.id,
      index: newIndex,
    );

    GroceryItemModel newGroceryItem = GroceryItemModel(groceryListItem: newListItem, userItem: newUserItem);
    firestoreDatabase.setGroceryItem(newGroceryItem, listId);
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

            for (int i = 0; i < listItems.length; i++) {
              for (int j = 0; j < userItems.length; j++) {
                if (listItems[i].id == userItems[j].id) {
                  final GroceryItemModel groceryItem = GroceryItemModel(
                    groceryListItem: listItems[i],
                    userItem: userItems[j],
                  );
                  items.add(groceryItem);
                  break;
                }
              }
            }

            if (items.isNotEmpty) {
              items.sort((a, b) => a.index.compareTo(b.index));
              return ReorderableListView(
                children: _buildListItems(context, items, firestoreDatabase, authProvider),
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex--;
                  }
                  // set old index to new
                  _setOrder(items[oldIndex], newIndex, firestoreDatabase);

                  // iterate over list and adjust the rest of the indices
                  if (oldIndex < newIndex) {
                    for (int i = newIndex; i > oldIndex; i--) {
                      _setOrder(items[i], items[i].index - 1, firestoreDatabase);
                    }
                  } else {
                    for (int i = newIndex; i < oldIndex; i++) {
                      _setOrder(items[i], items[i].index + 1, firestoreDatabase);
                    }
                  }
                },
              );
            } else {
              return EmptyContentWidget(
                title: AppLocalizations.of(context).translate("listsEmptyTopMsgDefaultTxt"),
                message: AppLocalizations.of(context).translate("listsEmptyBottomDefaultMsgTxt"),
                key: const Key('EmptyContentWidget'),
              );
            }
          } else if (snapshot.hasError) {
            print(snapshot.error.toString());
            return const CircularProgressIndicator();
          }
          return EmptyContentWidget(
            title: AppLocalizations.of(context).translate("listsEmptyTopMsgDefaultTxt"),
            message: AppLocalizations.of(context).translate("listsEmptyBottomDefaultMsgTxt"),
            key: const Key('EmptyContentWidget'),
          );
        });
  }
}
