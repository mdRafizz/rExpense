import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class GoogleAccountCard extends StatelessWidget {
  final bool isSignedIn;
  final String? userName;
  final String? userEmail;
  final String? photoUrl;
  final VoidCallback onSignIn;
  final VoidCallback? onSignOut;

  const GoogleAccountCard({
    super.key,
    required this.isSignedIn,
    this.userName,
    this.userEmail,
    this.photoUrl,
    required this.onSignIn,
    this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(16.w),
      child: isSignedIn
          ? Row(
              children: [
                // Profile Picture
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: photoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _DefaultAvatar(userName: userName);
                            },
                          ),
                        )
                      : _DefaultAvatar(userName: userName),
                ),
                Gap(14.w),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? 'User',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(2.h),
                      Text(
                        userEmail ?? '',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Gap(8.w),

                // Sign Out Button
                IconButton(
                  onPressed: onSignOut,
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 20.sp,
                    color: AppColors.danger,
                  ),
                  tooltip: 'Sign Out',
                ),
              ],
            )
          : Column(
              children: [
                Icon(
                  Icons.cloud_off_outlined,
                  size: 48.sp,
                  color: isDark
                      ? AppColors.textTertiaryDark
                      : AppColors.textTertiaryLight,
                ),
                Gap(12.h),
                Text(
                  'Not signed in',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                Gap(6.h),
                Text(
                  'Sign in with Google to enable cloud backup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Gap(16.h),
                ElevatedButton.icon(
                  onPressed: onSignIn,
                  icon: Icon(Icons.login_rounded, size: 18.sp),
                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  final String? userName;

  const _DefaultAvatar({this.userName});

  @override
  Widget build(BuildContext context) {
    final initial = userName?.isNotEmpty == true
        ? userName![0].toUpperCase()
        : 'U';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
