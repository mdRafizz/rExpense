import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r_expense/core/extensions/extensions.dart';
import 'package:r_expense/core/theme/app_color.dart';
import 'package:r_expense/features/auth/presentation/login_screen.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const .symmetric(horizontal: 12),
        child: Column(
          children: [
            SafeArea(child: SizedBox(height: 5)),
            Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    "Assalamu Alaikum".toBody2(),
                    "Rafizul Hasan".toSubtitle1(),
                  ],
                ),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.card,
                    border: Border.all(color: AppColor.divider, width: .5),
                  ),
                  alignment: .center,
                  child: "bell".toSvgIcon(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
