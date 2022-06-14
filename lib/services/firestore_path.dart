class FirestorePath {
  static String lists(String uid) => 'users/$uid/lists';
  static String groceryList(String uid, String listID) => 'users/$uid/lists/$listID';

  static String items(String uid) => 'users/$uid/items';
  static String item(String uid, String itemID) => 'users/$uid/items/$itemID';

  static String generalSettings(String uid) => 'users/$uid/settings/general';
}