import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/hive_models.dart';
import '../../data/repositories/shop_repository_impl.dart';
import '../../domain/entities/shop_entities.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/usecases/shop_usecases.dart';

final hiveBoxProvider = Provider<Box<ShoppingListModel>>((ref) {
  throw UnimplementedError('Hive box must be overridden in main');
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl(ref.watch(hiveBoxProvider));
});

final getSuggestedItemsUseCaseProvider = Provider((ref) {
  return GetSuggestedItemsUseCase(ref.watch(shopRepositoryProvider));
});

class ShopNotifier extends StateNotifier<List<ShoppingList>> {
  final ShopRepository _repository;

  ShopNotifier(this._repository) : super([]) {
    loadLists();
  }

  Future<void> loadLists() async {
    state = await _repository.getLists();
  }

  Future<void> createList(String title) async {
    final newList = ShoppingList(
      id: const Uuid().v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    await _repository.saveList(newList);
    await loadLists();
  }

  Future<void> deleteList(String id) async {
    await _repository.deleteList(id);
    await loadLists();
  }

  Future<void> addItemToList(String listId, String name, String category) async {
    final item = ShoppingItem(
      id: const Uuid().v4(),
      name: name,
      category: category,
    );
    await _repository.updateItemInList(listId, item);
    await loadLists();
  }
  
  Future<void> toggleItem(String listId, ShoppingItem item) async {
    final updated = item.copyWith(isCompleted: !item.isCompleted);
    await _repository.updateItemInList(listId, updated);
    await loadLists();
  }
}

final shopListProvider = StateNotifierProvider<ShopNotifier, List<ShoppingList>>((ref) {
  return ShopNotifier(ref.watch(shopRepositoryProvider));
});

final aiSuggestionsProvider = FutureProvider.autoDispose<List<ShoppingItem>>((ref) async {
  final useCase = ref.watch(getSuggestedItemsUseCaseProvider);
  return useCase.call(5);
});

final themeModeProvider = StateProvider<bool>((ref) => false);
