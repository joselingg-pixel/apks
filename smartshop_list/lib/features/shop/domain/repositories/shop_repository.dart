import '../entities/shop_entities.dart';

abstract class ShopRepository {
  Future<List<ShoppingList>> getLists();
  Future<void> saveList(ShoppingList list);
  Future<void> deleteList(String id);
  Future<void> updateItemInList(String listId, ShoppingItem item);
  Future<void> deleteItemFromList(String listId, String itemId);
  Future<List<ShoppingItem>> getSuggestedItems(int limit);
  Future<void> syncWithCloud(); 
}
