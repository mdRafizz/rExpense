import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/sync/sync_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<SyncCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(20),
        children: [
          // ── Cloud Sync Section ─────────────────────────────────────────────
          Text(
            'Cloud Backup',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<SyncCubit, SyncState>(
            builder: (context, state) {
              return _CloudSyncCard(state: state);
            },
          ),
          const SizedBox(height: 28),

          // ── Manage ────────────────────────────────────────────────────────
          Text(
            'Manage',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _TappableTile(
            icon: Icons.group_outlined,
            title: 'Trackers',
            subtitle: 'Manage spending profiles (Family, Wife, Child…)',
            onTap: () => context.push('/members'),
          ),
          const SizedBox(height: 28),

          // ── App Info ───────────────────────────────────────────────────────
          Text(
            'About',
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          const SizedBox(height: 8),
          _SettingsTile(
            icon: Icons.storage_outlined,
            title: 'Local Database',
            subtitle: 'Drift (SQLite) — reactive & offline-first',
          ),
        ],
      ),
    );
  }
}

class _CloudSyncCard extends StatelessWidget {
  final SyncState state;

  const _CloudSyncCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SyncCubit>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.cloud_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Google Drive',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _statusText(state),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _statusColor(state),
                      ),
                    ),
                  ],
                ),
              ),
              _statusIcon(state),
            ],
          ),

          if (state case SyncIdle(lastBackupTime: final t?))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Last backup: ${DateFormat('MMM d, y · h:mm a').format(t)}',
                style: AppTextStyles.labelSmall,
              ),
            ),

          if (state case SyncSuccess(:final message))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                ),
              ),
            ),

          if (state case SyncError(:final message))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                message,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.danger,
                ),
              ),
            ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          // Actions — exhaustive switch so every state renders something
          switch (state) {
            SyncLoading(:final message) => Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(message, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            SyncInitial() || SyncIdle(isSignedIn: false) => SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: cubit.signIn,
                  icon: const Icon(Icons.login, size: 18),
                  label: const Text('Sign in with Google'),
                ),
              ),
            // Signed-in idle, success, or error — show backup controls
            _ => Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: cubit.backup,
                          icon: const Icon(Icons.backup_outlined, size: 18),
                          label: const Text('Backup Now'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _confirmRestore(context, cubit),
                          icon: const Icon(Icons.restore, size: 18),
                          label: const Text('Restore'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: cubit.signOut,
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ),
                ],
              ),
          },
        ],
      ),
    );
  }

  String _statusText(SyncState state) => switch (state) {
        SyncIdle(isSignedIn: true, signedInEmail: final email) =>
          'Signed in as $email',
        SyncIdle() => 'Not signed in',
        SyncLoading(:final message) => message,
        SyncSuccess(signedInEmail: final email?) => 'Signed in as $email',
        SyncSuccess() => 'Backup successful',
        SyncError(:final message) => message,
        SyncInitial() => 'Checking sign-in status...',
      };

  Color _statusColor(SyncState state) => switch (state) {
        SyncIdle(isSignedIn: true) => AppColors.success,
        SyncSuccess() => AppColors.success,
        SyncError() => AppColors.danger,
        _ => AppColors.textSecondaryLight,
      };

  Widget _statusIcon(SyncState state) => switch (state) {
        SyncIdle(isSignedIn: true) =>
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        SyncSuccess() =>
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        SyncError() =>
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
        _ => const SizedBox.shrink(),
      };

  Future<void> _confirmRestore(BuildContext context, SyncCubit cubit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Data'),
        content: const Text(
          'This will replace all local data with the backup from Google Drive. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Restore',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) cubit.restore();
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TappableTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TappableTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
