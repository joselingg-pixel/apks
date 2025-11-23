import 'package:hive/hive.dart';
import '../../domain/entities/shop_entities.dart';
import '../../domain/repositories/shop_repository.dart';
import '../models/hive_models.dart';

class ShopRepositoryImpl implements ShopRepository {
  final Box<ShoppingListModel> _localBox;

  ShopRepositoryImpl(this._localBox);

  @override
  Future<List<ShoppingList>> getLists() async {
    return _localBox.values.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> saveList(ShoppingList list) async {
    final model = ShoppingListModel.fromEntity(list);
    await _localBox.put(list.id, model);
  }

  @override
  Future<void> deleteList(String id) async {
    await _localBox.delete(id);
  }

  @override
  Future<void> updateItemInList(String listId, ShoppingItem item) async {
    final listModel = _localBox.get(listId);
    if (listModel != null) {
      final index = listModel.items.indexWhere((element) => element.id == item.id);
      final itemModel = ShoppingItemModel.fromEntity(item);
      
      if (index != -1) {
        listModel.items[index] = itemModel;
      } else {
        listModel.items.add(itemModel);
      }
      await listModel.save();
    }
  }
  
  @override
  Future<void> deleteItemFromList(String listId, String itemId) async {
    final listModel = _localBox.get(listId);
    if (listModel != null) {
      listModel.items.removeWhere((item) => item.id == itemId);
      await listModel.save();
    }
  }

  @override
  Future<List<ShoppingItem>> getSuggestedItems(int limit) async {
    final allLists = _localBox.values;
    final frequencyMap = <String, int>{};
    final recentItemMap = <String, ShoppingItem>{};

    for (var list in allLists) {
      for (var item in list.items) {
        final key = item.name.toLowerCase().trim();
        frequencyMap[key] = (frequencyMap[key] ?? 0) + 1;
        recentItemMap[key] = item.toEntity(); 
      }
    }

    final sortedKeys = frequencyMap.keys.toList()
      ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

    return sortedKeys
        .take(limit)
        .map((key) => recentItemMap[key]!)
        .map((item) => item.copyWith(isCompleted: false, id: 'suggestion_${item.name}'))
        .toList();
  }

  @override
  Future<void> syncWithCloud() async {
    print("Sync with backend invoked - Not implemented yet.");
  }
}
