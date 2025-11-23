import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/shop_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Ajustes")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text("Modo Oscuro"),
            trailing: Switch(
              value: isDark,
              onChanged: (val) => ref.read(themeModeProvider.notifier).state = val,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_sync),
            title: const Text("Sincronización (Beta)"),
            subtitle: const Text("Conectar con Backend"),
            onTap: () {
              ref.read(shopRepositoryProvider).syncWithCloud();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Función no implementada aún (Backend Ready)")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Versión"),
            subtitle: const Text("2.0.0 (Build Enterprise)"),
          ),
        ],
      ),
    );
  }
}
