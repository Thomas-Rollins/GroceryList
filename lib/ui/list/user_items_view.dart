import 'package:flutter/material.dart';
import 'package:grocery_list/app_localizations.dart';
import 'package:grocery_list/models/user_item_model.dart';
import 'package:grocery_list/models/user_model.dart';
import 'package:grocery_list/providers/auth_provider.dart';
import 'package:grocery_list/routes.dart';
import 'package:grocery_list/services/firestore_database.dart';
import 'package:grocery_list/ui/list/empty_content.dart';
import 'package:grocery_list/ui/shared/favourite_star.dart';
import 'package:provider/provider.dart';

class UserItemsView extends StatelessWidget {
  UserItemsView({Key? key}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _buildListItems(BuildContext context, List<UserItemModel> items, firestoreDatabase, authProvider) {
    List<Widget> tiles = [];

    for (int index = 0; index < items.length; index++) {
      tiles.add(
        Card(
          margin: const EdgeInsets.all(8),
          color: Theme.of(context).cardColor,
          elevation: 5,
          child: Row(
            children: [
              Column(
                children: [
                  Text("${items[index].name}"),
                  Text(items[index].brand ?? '(Unset)'),
                ],
              ),
              Text(items[index].category ?? '(Unset)'),
              Text(
                  "${AppLocalizations.of(context).translate("currencySymbolBefore")}${items[index].costPerItem} ${AppLocalizations.of(context).translate("currencySymbolAfter")}"),
              SizedBox(
                width: 100,
                height: 40,
                child: GestureDetector(
                  child: FavouriteStar(isFavourite: items[index].isFavourite ?? false),
                  onTap: () => {_updateFavourite(items[index], firestoreDatabase)},
                ),
              ),
            ],
          ),
        ),
      );
    }
    return tiles;
  }

  void _updateFavourite(UserItemModel item, firestoreDatabase) {
    UserItemModel newUserItem = UserItemModel(
      id: item.id,
      isFavourite: !(item.isFavourite ?? true),
      lastUpdated: item.curTime,
    );
    firestoreDatabase.setUserItem(newUserItem);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase = Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
            stream: authProvider.user,
            builder: (context, snapshot) {
              final UserModel? user = snapshot.data as UserModel?;
              return Text(user != null && user.uid != 'null'
                  ? "${user.email!} - ${AppLocalizations.of(context).translate("homeAppBarTitle")}"
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
            Routes.user_items_view,
          );
        },
      ),
      body: StreamBuilder(
          stream: firestoreDatabase.userItemsStream(),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<UserItemModel> items = snapshot.data as List<UserItemModel>;
              if (items.isNotEmpty) {
                items.sort((a, b) => a.name!.compareTo(b.name!));
                return ListView(
                  children: _buildListItems(context, items, firestoreDatabase, authProvider),
                );
              } else {
                return EmptyContentWidget(
                  title: AppLocalizations.of(context).translate("userItemsEmptyTopDefaultMsgTxt"),
                  message: AppLocalizations.of(context).translate("userItemsEmptyBottomDefaultMsgTxt"),
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
          }),
    );
  }
}
