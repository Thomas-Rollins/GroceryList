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
    // final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

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
          // StreamBuilder(
          //     stream: firestoreDatabase.listsStream(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         List<ListModel> lists = snapshot.data as List<ListModel>;
          //         return Visibility(visible: lists.isNotEmpty ? true : false, child: const Text("Extra actions"));
          //       } else {
          //         return const SizedBox(
          //           width: 0,
          //           height: 0,
          //         );
          //       }
          //     }),
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
      //body: WillPopScope(onWillPop: () async => false, child: _buildBodySection(context, authProvider)),
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
                title: AppLocalizations.of(context).translate("todosEmptyTopMsgDefaultTxt"),
                message: AppLocalizations.of(context).translate("todosEmptyBottomDefaultMsgTxt"),
                key: const Key('EmptyContentWidget'),
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContentWidget(
              title: AppLocalizations.of(context).translate("todosErrorTopMsgTxt"),
              message: AppLocalizations.of(context).translate("todosErrorBottomMsgTxt"),
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
                        Navigator.of(context).pushNamed(
                          Routes.create_edit_list,
                        );
                      },
                    ),
                    body: ItemsScreen(listId: lists[index].id),
                    // body: WillPopScope(onWillPop: () async => false, child: ItemsScreen(listId: lists[index].id)),
                    //const Text("List Items"),
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
                            if(kDebugMode) {
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

      // tiles.add(Dismissible(
      //   background: Container(
      //     color: Colors.red,
      //     child: Center(
      //         child: Text(
      //       AppLocalizations.of(context).translate("todosDismissibleMsgTxt"),
      //       style: TextStyle(color: Theme.of(context).canvasColor),
      //     )),
      //   ),
      //   key: Key(lists[index].id),
      //   onDismissed: (direction) {
      //     firestoreDatabase.deleteTodo(lists[index]);
      //
      //     // _scaffoldKey.currentState!.showSnackBar(SnackBar(
      //     _scaffoldKey.currentState!.showSnackBar(SnackBar(
      //       backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      //       content: Text(
      //         AppLocalizations.of(context).translate("todosSnackBarContent") + lists[index].name,
      //         style: TextStyle(color: Theme.of(context).canvasColor),
      //       ),
      //       duration: const Duration(seconds: 3),
      //       action: SnackBarAction(
      //         label: AppLocalizations.of(context).translate("todosSnackBarActionLbl"),
      //         textColor: Theme.of(context).canvasColor,
      //         onPressed: () {
      //           firestoreDatabase.setList(lists[index]);
      //         },
      //       ),
      //     ));
      //   },
      //   child: ListTile(
      //     leading: Checkbox(
      //         value: lists[index].isSelected,
      //         onChanged: (value) {
      //           ListModel newList = ListModel(
      //               id: lists[index].id,
      //               index: index,
      //               name: lists[index].name,
      //               isFavourite: lists[index].isFavourite,
      //               isSelected: value!);
      //           firestoreDatabase.setList(newList);
      //         }),
      //     title: GestureDetector(child: Text(lists[index].name), onDoubleTap: () => {}),
      //     onTap: () {
      //       // navigate to list view here
      //       Navigator.of(context).pushNamed(Routes.list_view, arguments: lists[index]);
      //     },
      //     trailing: GestureDetector(
      //         child: FavouriteStar(isFavourite: lists[index].isFavourite),
      //         onTap: () => {_updateFavourite(lists[index], firestoreDatabase)}),
      //   ),
      // ));
    }
    return tiles;
  }
}
