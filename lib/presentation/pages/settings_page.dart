import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:mvvm_clean_template/l10n/app_localizations.dart';
import 'package:mvvm_clean_template/presentation/viewmodels/settings_viewmodel.dart';

/// Settings page for theme and language configuration
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsViewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Section
          _buildSectionHeader(context, l10n.theme, Icons.palette),
          const SizedBox(height: 8),
          _buildThemeCard(context, settingsViewModel, l10n),
          const SizedBox(height: 24),

          // Language Section
          _buildSectionHeader(context, l10n.language, Icons.language),
          const SizedBox(height: 8),
          _buildLanguageCard(context, settingsViewModel, l10n),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, l10n.about, Icons.info_outline),
          const SizedBox(height: 8),
          _buildAboutCard(context, l10n),
          const SizedBox(height: 24),

          // Reset Button
          Center(
            child: OutlinedButton.icon(
              onPressed: () => _showResetDialog(context, settingsViewModel, l10n),
              icon: const Icon(Icons.restore),
              label: Text(l10n.resetToDefaults),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(BuildContext context, SettingsViewModel viewModel, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Selector
            Text(
              l10n.themeDescription,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              viewModel,
              ThemeMode.light,
              l10n.themeLight,
              Icons.light_mode,
              l10n,
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              viewModel,
              ThemeMode.dark,
              l10n.themeDark,
              Icons.dark_mode,
              l10n,
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              viewModel,
              ThemeMode.system,
              l10n.themeSystem,
              Icons.brightness_auto,
              l10n,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Quick Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.toggleTheme,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Switch(
                  value: viewModel.isDarkMode,
                  onChanged: (value) => viewModel.toggleTheme(),
                  thumbIcon: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Icon(Icons.dark_mode);
                    }
                    return const Icon(Icons.light_mode);
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    SettingsViewModel viewModel,
    ThemeMode mode,
    String title,
    IconData icon,
    AppLocalizations l10n,
  ) {
    final isSelected = viewModel.themeMode == mode;

    return InkWell(
      onTap: () => viewModel.setThemeMode(mode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
      BuildContext context, SettingsViewModel viewModel, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.languageDescription,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildLanguageOption(
              context,
              viewModel,
              const Locale('en'),
              l10n.languageEnglish,
              'EN',
            ),
            const SizedBox(height: 8),
            _buildLanguageOption(
              context,
              viewModel,
              const Locale('th'),
              l10n.languageThai,
              'TH',
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            // Quick Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.toggleLanguage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ElevatedButton.icon(
                  onPressed: () => viewModel.toggleLanguage(),
                  icon: const Icon(Icons.swap_horiz),
                  label: Text(
                    viewModel.locale.languageCode == 'en' ? 'EN' : 'TH',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    SettingsViewModel viewModel,
    Locale locale,
    String title,
    String code,
  ) {
    final isSelected = viewModel.locale == locale;

    return InkWell(
      onTap: () => viewModel.setLocale(locale),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : null,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              child: Text(
                code,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flutter_dash, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${l10n.version} 1.0.0',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: const Text('Flutter 3+'),
                  avatar: const Icon(Icons.flutter_dash, size: 18),
                ),
                Chip(
                  label: const Text('MVVM'),
                  avatar: const Icon(Icons.architecture, size: 18),
                ),
                Chip(
                  label: const Text('GoRouter'),
                  avatar: const Icon(Icons.route, size: 18),
                ),
                Chip(
                  label: const Text('Provider'),
                  avatar: const Icon(Icons.inventory, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(
      BuildContext context, SettingsViewModel viewModel, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetToDefaults),
        content: Text(l10n.reset),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              viewModel.resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.success),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }
}
