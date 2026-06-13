import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/glass_card.dart';
import 'widgets/google_account_card.dart';
import 'widgets/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSignedIn = false;
  bool isDarkMode = false;
  bool isBackingUp = false;
  bool isSyncing = false;
  double backupProgress = 0.0;
  double syncProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(8.h),

                  // Google Account Section
                  _SectionHeader(title: 'Account'),
                  Gap(12.h),
                  GoogleAccountCard(
                    isSignedIn: isSignedIn,
                    userName: isSignedIn ? 'John Doe' : null,
                    userEmail: isSignedIn ? 'john.doe@gmail.com' : null,
                    onSignIn: () {
                      // TODO: Implement Google Sign In
                      setState(() {
                        isSignedIn = true;
                      });
                    },
                    onSignOut: () {
                      // TODO: Implement Sign Out
                      setState(() {
                        isSignedIn = false;
                      });
                    },
                  ),
                  Gap(24.h),

                  // Backup & Sync Section
                  if (isSignedIn) ...[
                    _SectionHeader(title: 'Backup & Sync'),
                    Gap(12.h),
                    GlassCard(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          // Backup Now
                          SettingsTile(
                            icon: Icons.backup_rounded,
                            title: 'Backup Now',
                            subtitle: isBackingUp
                                ? 'Backing up... ${(backupProgress * 100).toInt()}%'
                                : 'Last backup: Never',
                            iconColor: AppColors.primary,
                            trailing: isBackingUp
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: backupProgress,
                                    ),
                                  )
                                : null,
                            onTap: isBackingUp
                                ? null
                                : () {
                                    // TODO: Implement backup
                                    setState(() {
                                      isBackingUp = true;
                                      backupProgress = 0.0;
                                    });
                                    // Simulate backup progress
                                    _simulateProgress(
                                      onUpdate: (progress) {
                                        setState(() {
                                          backupProgress = progress;
                                        });
                                      },
                                      onComplete: () {
                                        setState(() {
                                          isBackingUp = false;
                                        });
                                      },
                                    );
                                  },
                          ),

                          // Sync Now
                          SettingsTile(
                            icon: Icons.sync_rounded,
                            title: 'Sync Now',
                            subtitle: isSyncing
                                ? 'Syncing... ${(syncProgress * 100).toInt()}%'
                                : 'Last sync: Never',
                            iconColor: AppColors.income,
                            trailing: isSyncing
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: syncProgress,
                                    ),
                                  )
                                : null,
                            onTap: isSyncing
                                ? null
                                : () {
                                    // TODO: Implement sync
                                    setState(() {
                                      isSyncing = true;
                                      syncProgress = 0.0;
                                    });
                                    _simulateProgress(
                                      onUpdate: (progress) {
                                        setState(() {
                                          syncProgress = progress;
                                        });
                                      },
                                      onComplete: () {
                                        setState(() {
                                          isSyncing = false;
                                        });
                                      },
                                    );
                                  },
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    Gap(24.h),
                  ],

                  // Data Management Section
                  _SectionHeader(title: 'Data Management'),
                  Gap(12.h),
                  GlassCard(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.category_outlined,
                          title: 'Manage Categories',
                          subtitle: 'Add, edit, or delete categories',
                          iconColor: AppColors.categoryPalette[0],
                          onTap: () {
                            // TODO: Navigate to manage categories
                          },
                        ),
                        SettingsTile(
                          icon: Icons.people_outline_rounded,
                          title: 'Manage Contributors',
                          subtitle: 'Add, edit, or delete contributors',
                          iconColor: AppColors.categoryPalette[1],
                          onTap: () {
                            // TODO: Navigate to manage contributors
                          },
                        ),
                        SettingsTile(
                          icon: Icons.person_outline_rounded,
                          title: 'Manage Beneficiaries',
                          subtitle: 'Add, edit, or delete beneficiaries',
                          iconColor: AppColors.categoryPalette[2],
                          showDivider: false,
                          onTap: () {
                            // TODO: Navigate to manage beneficiaries
                          },
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),

                  // Appearance Section
                  _SectionHeader(title: 'Appearance'),
                  Gap(12.h),
                  GlassCard(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          title: 'Theme',
                          subtitle: isDark ? 'Dark Mode' : 'Light Mode',
                          iconColor: isDark
                              ? const Color(0xFF9D97FF)
                              : const Color(0xFFFFBE0B),
                          trailing: Switch(
                            value: isDark,
                            onChanged: (value) {
                              // TODO: Toggle theme
                              setState(() {
                                isDarkMode = value;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),

                  // About Section
                  _SectionHeader(title: 'About'),
                  Gap(12.h),
                  GlassCard(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          title: 'Version',
                          subtitle: '1.0.0',
                          iconColor: AppColors.textSecondaryLight,
                          trailing: const SizedBox.shrink(),
                        ),
                        SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          iconColor: AppColors.textSecondaryLight,
                          onTap: () {
                            // TODO: Show privacy policy
                          },
                        ),
                        SettingsTile(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          iconColor: AppColors.textSecondaryLight,
                          showDivider: false,
                          onTap: () {
                            // TODO: Show terms of service
                          },
                        ),
                      ],
                    ),
                  ),
                  Gap(24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _simulateProgress({
    required Function(double) onUpdate,
    required VoidCallback onComplete,
  }) {
    int progress = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      progress += 5;
      onUpdate(progress / 100);
      return progress < 100;
    }).then((_) => onComplete());
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: isDark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
        letterSpacing: 0.5,
      ),
    );
  }
}
