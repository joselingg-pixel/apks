import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/shop_providers.dart';
import '../../domain/entities/shop_entities.dart';
import '../../../../core/utils/pdf_helper.dart';

class ListDetailScreen extends ConsumerWidget {
  final String listId;

  const ListDetailScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopList = ref.watch(shopListProvider);
    final ShoppingList? list = shopList.where((l) => l.id == listId).firstOrNull;

    if (list == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final aiSuggestions = ref.watch(aiSuggestionsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(list.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: "Exportar PDF",
                onPressed: () => PdfHelper.generateAndShare(list),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: "Borrar lista",
                onPressed: () {
                  ref.read(shopListProvider.notifier).deleteList(listId);
                  Navigator.pop(context);
                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: aiSuggestions.when(
              data: (suggestions) {
                if (suggestions.isEmpty) return const SizedBox.shrink();
                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Center(child: Text("✨ Sugerencias:", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),
                      const SizedBox(width: 10),
                      ...suggestions.map((item) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          avatar: const Icon(Icons.auto_awesome, size: 16),
                          label: Text(item.name),
                          onPressed: () {
                             ref.read(shopListProvider.notifier).addItemToList(listId, item.name, item.category);
                          },
                        ),
                      ))
                    ],
                  ),
                ).animate().fadeIn();
              },
              error: (_,__) => const SizedBox.shrink(),
              loading: () => const LinearProgressIndicator(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = list.items[index];
                return Dismissible(
                  key: Key(item.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), child: const Icon(Icons.delete, color: Colors.white)),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {}, 
                  child: CheckboxListTile(
                    value: item.isCompleted,
                    title: Text(
                      item.name,
                      style: TextStyle(
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                        color: item.isCompleted ? Colors.grey : null
                      ),
                    ),
                    subtitle: Text(item.category, style: const TextStyle(fontSize: 12)),
                    secondary: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(item.name[0].toUpperCase()),
                    ),
                    onChanged: (_) => ref.read(shopListProvider.notifier).toggleItem(listId, item),
                  ).animate().fadeIn(),
                );
              },
              childCount: list.items.length,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemSheet(context, ref),
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }

  void _showAddItemSheet(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: "General");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20, left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Añadir Producto", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder()), autofocus: true),
            const SizedBox(height: 10),
            TextField(controller: catCtrl, decoration: const InputDecoration(labelText: "Categoría", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Guardar"),
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  ref.read(shopListProvider.notifier).addItemToList(listId, nameCtrl.text, catCtrl.text);
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      )
    );
  }
}
