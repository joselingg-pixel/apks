import 'package:equatable/equatable.dart';

class ShoppingItem extends Equatable {
  final String id;
  final String name;
  final String category;
  final bool isCompleted;
  final double? price;

  const ShoppingItem({
    required this.id,
    required this.name,
    this.category = 'General',
    this.isCompleted = false,
    this.price,
  });

  ShoppingItem copyWith({
    String? name,
    String? category,
    bool? isCompleted,
    double? price,
  }) {
    return ShoppingItem(
      id: this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [id, name, category, isCompleted, price];
}

class ShoppingList extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ShoppingItem> items;

  const ShoppingList({
    required this.id,
    required this.title,
    required this.createdAt,
    this.items = const [],
  });

  double get progress {
    if (items.isEmpty) return 0.0;
    final completed = items.where((i) => i.isCompleted).length;
    return completed / items.length;
  }

  ShoppingList copyWith({
    String? title,
    List<ShoppingItem>? items,
  }) {
    return ShoppingList(
      id: this.id,
      title: title ?? this.title,
      createdAt: this.createdAt,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [id, title, createdAt, items];
}
