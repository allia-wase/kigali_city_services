import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/auth_service.dart';

final notificationPrefProvider = StateProvider<bool>((ref) => false);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notify = ref.watch(notificationPrefProvider);
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                _ThemeChip(
                  mode: AppThemeMode.light,
                  label: 'Light',
                  icon: Icons.light_mode,
                  selected: themeMode == AppThemeMode.light,
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.light),
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  mode: AppThemeMode.dark,
                  label: 'Dark',
                  icon: Icons.dark_mode,
                  selected: themeMode == AppThemeMode.dark,
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.dark),
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  mode: AppThemeMode.system,
                  label: 'System',
                  icon: Icons.brightness_auto,
                  selected: themeMode == AppThemeMode.system,
                  onTap: () =>
                      ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.system),
                ),
              ],
            ),
            const SizedBox(height: 20),
            profile.when(
              data: (p) => p == null
                  ? const Text('No profile')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${p.email}'),
                        if (p.displayName != null)
                          Text('Name: ${p.displayName}'),
                      ],
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Location notifications'),
                Switch(
                  value: notify,
                  onChanged: (v) =>
                      ref.read(notificationPrefProvider.notifier).state = v,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => AuthService.instance.signOut(),
              child: const Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.mode,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final AppThemeMode mode;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = selected
        ? (isDark ? Colors.black87 : Colors.white)
        : Theme.of(context).iconTheme.color ?? Colors.grey;
    return FilterChip(
      avatar: Icon(icon, size: 18, color: iconColor),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
