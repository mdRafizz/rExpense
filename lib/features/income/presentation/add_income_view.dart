import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:r_expense/core/extensions/context_extension.dart';
import 'package:r_expense/core/widgets/custom_labeled_text_field.dart';

import '../../../core/extensions/picture_extensions.dart';
import '../../../core/extensions/string_extensions.dart';

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
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.cardColor,
                      ),
                      alignment: .center,
                      child: "back".toSvgIcon(
                        color: context.textColor,
                        size: 12,
                      ),
                    ),
                  ),
                  Gap(20),
                  "Add Income".toHeadline5(),
                ],
              ),
              Gap(25),
              Container(
                padding: const .symmetric(horizontal: 10, vertical: 13),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: const .all(.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CustomLabeledTextField(
                      label: "Amount",
                      keyboardType: .number,
                      hintText: "Enter amount",
                      textFieldHeight: 40,
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              "Amount Type".toMandatoryLabel(context),
                              const Gap(8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  color: context.scaffoldColor,
                                  // Sets the background color
                                  child: DropdownButtonHideUnderline(
                                    // Removes the bottom divider
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      // Makes sure it fills the width
                                      hint: "Select Type".toCaption(
                                        color: context.dividerColor,
                                      ),
                                      dropdownColor: context.scaffoldColor,
                                      // Sets the menu popup color
                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: context.textColor,
                                        size: 20,
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: 1,
                                          child: "Bank".toBody2(),
                                        ),
                                        DropdownMenuItem(
                                          value: 2,
                                          child: "Cash".toBody2(),
                                        ),
                                        DropdownMenuItem(
                                          value: 3,
                                          child: "Wallet".toBody2(),
                                        ),
                                      ],
                                      onChanged: (val) {
                                        // Handle logic
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              "Date".toSubtitle1(),
                              const Gap(8),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: context.scaffoldColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Replace with your date variable logic
                                    "Select Date".toCaption(
                                      color: context
                                          .dividerColor, // Or context.textColor if date is selected
                                    ),
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      size: 18,
                                      color: context.dividerColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
