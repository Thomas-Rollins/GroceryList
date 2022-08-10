import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/models/list_model.dart';
import 'package:grocery_list/models/user_model.dart';
import 'package:grocery_list/providers/auth_provider.dart';
import 'package:grocery_list/routes.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:grocery_list/ui/list/empty_content.dart';
import 'package:grocery_list/ui/list/list_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../shared/favourite_star.dart';

class ListsScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ListsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel? user = snapshot.data as UserModel?;
              return Text(user != null && user.uid != 'null'
                  ? user.email! + " - " + AppLocalizations.of(context).translate("homeAppBarTitle")
                  : AppLocalizations.of(context).translate("homeAppBarTitle"));
            }),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.setting);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.create_edit_list,
          );
        },
      ),
      body: _buildBodySection(context, authProvider),
    );
  }

  Widget _buildBodySection(BuildContext context, authProvider) {
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder(
        stream: firestoreDatabase.listsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ListModel> lists = snapshot.data as List<ListModel>;
            if (lists.isNotEmpty) {
              lists.sort((a, b) => a.index.compareTo(b.index));
              return ReorderableListView(
                children: _buildListItems(context, lists, firestoreDatabase, authProvider),
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex--;
                  }
                  // set old index to new
                  _setOrder(lists[oldIndex], newIndex, firestoreDatabase);

                  // iterate over list and adjust the rest of the indices
                  if (oldIndex < newIndex) {
                    for (int i = newIndex; i > oldIndex; i--) {
                      _setOrder(lists[i], lists[i].index - 1, firestoreDatabase);
                    }
                  } else {
                    for (int i = newIndex; i < oldIndex; i++) {
                      _setOrder(lists[i], lists[i].index + 1, firestoreDatabase);
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
            return EmptyContentWidget(
              title: AppLocalizations.of(context).translate("listsErrorTopMsgTxt"),
              message: AppLocalizations.of(context).translate("listsErrorBottomMsgTxt"),
              key: const Key('EmptyContentWidget'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  void _setOrder(ListModel list, int newIndex, firestoreDatabase) {
    ListModel newList = ListModel(
      id: list.id,
      index: newIndex,
      name: list.name,
      isFavourite: list.isFavourite,
      isSelected: list.isSelected,
      lastUpdated: list.lastUpdated,
    );

    firestoreDatabase.setList(newList);
  }

  void _updateFavourite(ListModel list, firestoreDatabase) {
    ListModel newList = ListModel(
        id: list.id,
        index: list.index,
        name: list.name,
        isFavourite: !list.isFavourite,
        isSelected: list.isSelected,
        lastUpdated: list.curTime);
    firestoreDatabase.setList(newList);
  }

  List<Widget> _buildListItems(context, lists, firestoreDatabase, authProvider) {
    List<Widget> tiles = [];

    for (int index = 0; index < lists.length; index++) {
      final String formattedDate = DateFormat('yMd').add_Hm().format(lists[index].lastUpdated.toDate());
      tiles.add(
        GestureDetector(
          key: Key("${lists[index].id} card"),
          onTap: () => {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    //key: _scaffoldKey,
                    appBar: AppBar(
                      title: StreamBuilder(
                          stream: authProvider.user,
                          builder: (context, snapshot) {
                            final UserModel? user = snapshot.data as UserModel?;
                            return Text(user != null && user.uid != 'null'
                                ? user.email! + " - " + lists[index].name
                                : AppLocalizations.of(context).translate("homeAppBarTitle"));
                          }),
                      actions: <Widget>[
                        IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: () {
                              Navigator.of(context).pushNamed(Routes.setting);
                            }),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        // #TODO: set up new item page
                        // Navigator.of(context).pushNamed(
                        //   Routes.create_edit_list,
                        // );
                      },
                    ),
                    body: ItemsScreen(listId: lists[index].id),
                  ),
                ),
              ),
            )
          },
          child: Card(
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
                      Padding(padding: const EdgeInsets.fromLTRB(8, 0, 8, 0), child: Text(lists[index].name)),
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
                Text("Total: \$${lists[index].total}"),
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
                              print("Deleted ${lists[index].name}");
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
                          child: FavouriteStar(isFavourite: lists[index].isFavourite),
                          onTap: () => {_updateFavourite(lists[index], firestoreDatabase)}),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tiles;
  }
}
