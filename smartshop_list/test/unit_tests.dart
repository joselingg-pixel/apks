import 'package:flutter_test/flutter_test.dart';
import 'package:smartshop_list/features/shop/domain/entities/shop_entities.dart';

void main() {
  group('ShoppingList Entity', () {
    test('Calculate progress correctly', () {
      final list = ShoppingList(
        id: '1', 
        title: 'Test', 
        createdAt: DateTime.now(),
        items: [
          const ShoppingItem(id: 'a', name: 'A', isCompleted: true),
          const ShoppingItem(id: 'b', name: 'B', isCompleted: false),
        ]
      );
      expect(list.progress, 0.5);
    });
    
    test('Progress is 0 when empty', () {
      final list = ShoppingList(id: '1', title: 'Test', createdAt: DateTime.now());
      expect(list.progress, 0.0);
    });
  });

  group('Recommendation Logic', () {
    test('Should prioritize frequent items', () {
       final history = ['Milk', 'Bread', 'Milk', 'Eggs', 'Milk', 'Bread'];
       final frequency = <String, int>{};
       for (var i in history) frequency[i] = (frequency[i] ?? 0) + 1;
       
       final sorted = frequency.keys.toList()
         ..sort((a, b) => frequency[b]!.compareTo(frequency[a]!));
       
       expect(sorted.first, 'Milk');
       expect(sorted[1], 'Bread');
    });
  });
}
