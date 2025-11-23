import 'package:hive/hive.dart';
import '../../domain/entities/shop_entities.dart';

part 'hive_models.g.dart';

@HiveType(typeId: 0)
class ShoppingItemModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final String category;
  @HiveField(3) final bool isCompleted;
  @HiveField(4) final double? price;

  ShoppingItemModel({
    required this.id, 
    required this.name, 
    required this.category, 
    required this.isCompleted, 
    this.price
  });

  factory ShoppingItemModel.fromEntity(ShoppingItem item) => ShoppingItemModel(
    id: item.id,
    name: item.name,
    category: item.category,
    isCompleted: item.isCompleted,
    price: item.price,
  );

  ShoppingItem toEntity() => ShoppingItem(
    id: id,
    name: name,
    category: category,
    isCompleted: isCompleted,
    price: price,
  );
}

@HiveType(typeId: 1)
class ShoppingListModel extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String title;
  @HiveField(2) final DateTime createdAt;
  @HiveField(3) final List<ShoppingItemModel> items;

  ShoppingListModel({
    required this.id, 
    required this.title, 
    required this.createdAt, 
    required this.items
  });

  factory ShoppingListModel.fromEntity(ShoppingList list) => ShoppingListModel(
    id: list.id,
    title: list.title,
    createdAt: list.createdAt,
    items: list.items.map((e) => ShoppingItemModel.fromEntity(e)).toList(),
  );

  ShoppingList toEntity() => ShoppingList(
    id: id,
    title: title,
    createdAt: createdAt,
    items: items.map((e) => e.toEntity()).toList(),
  );
}
