import '../../../../core/core_definitions.dart';
import '../entities/shop_entities.dart';
import '../repositories/shop_repository.dart';

class GetSuggestedItemsUseCase implements UseCase<List<ShoppingItem>, int> {
  final ShopRepository repository;
  GetSuggestedItemsUseCase(this.repository);

  @override
  Future<List<ShoppingItem>> call(int limit) async {
    return await repository.getSuggestedItems(limit);
  }
}
