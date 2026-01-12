import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:r_expense/core/extensions/context_extension.dart';
import 'package:r_expense/core/widgets/custom_labeled_text_field.dart';

import '../../../core/extensions/picture_extensions.dart';
import '../../../core/extensions/string_extensions.dart';

class AddWalletView extends StatelessWidget {
  const AddWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.scaffoldColor,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: context.cardColor,
        body: Padding(
          padding: const .symmetric(horizontal: 12.0),
          child: ListView(
            padding: const .all(0),
            physics: const BouncingScrollPhysics(),
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
                  "Add Wallet".toHeadline5(),
                ],
              ),
              Gap(25),
              Container(
                // padding: const .symmetric(horizontal: 10, vertical: 13),
                decoration: BoxDecoration(
                  /*color: context.cardColor,
                  gradient: LinearGradient(colors: [
                    "7fabc8".toColor(),
                    "c4d9ee".toColor()
                  ]),*/
                  image: Theme.of(context).brightness == Brightness.dark
                      ? "dCard2".toContainerBG()
                      : "lCard3".toContainerBG(),
                  // color: context.cardColor",
                  borderRadius: const .all(.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: const .all(.circular(10)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const .symmetric(horizontal: 10, vertical: 13),
                      decoration: BoxDecoration(
                        color: context.cardColor.withValues(alpha: .2),
                        borderRadius: const .all(.circular(10)),
                        border: .all(
                          width: 1,
                          color: context.cardColor.withValues(alpha: .3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomLabeledTextField(
                            label: "Name",
                            keyboardType: .text,
                            hintText: "Enter name",
                            textFieldHeight: 40,
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    "Type".toMandatoryLabel(context),
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
                                            dropdownColor:
                                                context.scaffoldColor,
                                            // Sets the menu popup color
                                            icon: Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: context.textColor,
                                              size: 20,
                                            ),
                                            items: [
                                              DropdownMenuItem(
                                                value: 1,
                                                child: "Cash".toBody2(),
                                              ),
                                              DropdownMenuItem(
                                                value: 2,
                                                child: "Bank".toBody2(),
                                              ),
                                              DropdownMenuItem(
                                                value: 3,
                                                child: "Mobile Banking"
                                                    .toBody2(),
                                              ),
                                              DropdownMenuItem(
                                                value: 4,
                                                child: "Credit Card".toBody2(),
                                              ),
                                              DropdownMenuItem(
                                                value: 5,
                                                child: "Debit Card".toBody2(),
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
                                    "Opening Date".toSubtitle1(),
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
                                          "Select Date".toCaption(
                                            color: context.dividerColor,
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
                  ),
                ),
              ),
              Gap(20),
              Container(
                padding: const .symmetric(horizontal: 10, vertical: 13),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    CustomLabeledTextField(
                      label: "Account Number",
                      isMandatory: false,
                      keyboardType: .number,
                      hintText: "Enter account number",
                      textFieldHeight: 40,
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomLabeledTextField(
                            label: "Opening Balance",
                            keyboardType: .number,
                            hintText: "Enter opening balance",
                            textFieldHeight: 40,
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: CustomLabeledTextField(
                            label: "Current Balance",
                            keyboardType: .number,
                            hintText: "Enter current balance",
                            textFieldHeight: 40,
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
