import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:r_expense/core/extensions/context_extension.dart';

import '../../../core/extensions/picture_extensions.dart';
import '../../../core/extensions/string_extensions.dart';
import '../../../core/theme/text_styles.dart';

class AddIncomeView extends StatelessWidget {
  const AddIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.scaffoldColor,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Padding(
          padding: const .symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .start,
            children: [
              SafeArea(child: SizedBox(height: 5)),
              Row(
                crossAxisAlignment: .center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: "back".toSvgIcon(color: context.textColor),
                  ),
                  Gap(20),
                  "Add Income".toHeadline5(),
                ],
              ),
              Gap(20),
              Container(
                padding: const .symmetric(
                  horizontal: 10,
                  vertical: 13
                ),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    "Amount".toSubtitle1(),
                    Gap(8),
                    ClipRRect(
                      borderRadius: .all(.circular(10)),
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          textAlignVertical: .center,
                          keyboardType: TextInputType.number,
                          style: TextStyles.regular(color: context.textColor,fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: .all(12),
                            fillColor: context.scaffoldColor,
                            filled: true,
                            hintText: "Enter Amount",
                            hintStyle: TextStyles.regular(color: context.dividerColor,fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
