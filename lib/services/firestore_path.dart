class FirestorePath {
  // user specific lists
  static String lists(String uid) => 'users/$uid/lists';
  static String groceryList(String uid, String listID) => 'users/$uid/lists/$listID';

  // user specific items
  static String items(String uid) => 'users/$uid/items';
  static String item(String uid, String itemID) => 'users/$uid/items/$itemID';

  // list specific Items
  static String listItems(String uid, String listID) => 'users/$uid/lists/$listID/items';
  static String listItemDetails(String uid, String listID, String itemID) => 'users/$uid/lists/$listID/items/$itemID';

  // settings
  static String generalSettings(String uid) => 'users/$uid/settings/general';
}
