import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:r_expense/core/extensions/context_extension.dart';
import 'package:r_expense/core/widgets/custom_labeled_text_field.dart';
import 'package:r_expense/core/widgets/glassmorphic_card.dart';

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
        systemNavigationBarIconBrightness: context.inverseBrightness,
      ),
      child: Scaffold(
        /*appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: "back".toSvgIcon(size: 17, color: context.textColor),
            ),
          ),
          leadingWidth: 50,
          title: Text("Add Wallet"),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size(double.maxFinite, 10),
            child: SizedBox(),
          ),
        ),*/
        body: Column(
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                const SafeArea(child: SizedBox(height: 2)),
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    const Gap(12),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: "back".toSvgIcon(
                            color: context.textColor,
                            size: 17,
                          ),
                        ),
                      ),
                    ),
                    Gap(15),
                    "Add Wallet".toHeadline6(),
                  ],
                ),
                const Gap(15),
                /*Divider(
                    color: context.textColor.withValues(alpha: .2),
                    height: 1,
                    thickness: 1,
                  ),*/
              ],
            ),
            Expanded(
              child: ListView(
                padding: const .symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                children: [
                  const Gap(15),
                  GlassmorphicCard(
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
                                      color: context.textFieldColor,
                                      // Sets the background color
                                      child: DropdownButtonHideUnderline(
                                        // Removes the bottom divider
                                        child: DropdownButton<int>(
                                          isExpanded: true,
                                          // Makes sure it fills the width
                                          hint: "Select Type".toCaption(
                                            color: context.textColor.withValues(
                                              alpha: .4,
                                            ),
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
                                              child: "Cash".toBody2(),
                                            ),
                                            DropdownMenuItem(
                                              value: 2,
                                              child: "Bank".toBody2(),
                                            ),
                                            DropdownMenuItem(
                                              value: 3,
                                              child: "Mobile Banking".toBody2(),
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
                                      color: context.textFieldColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        "Select Date".toCaption(
                                          color: context.textColor.withValues(
                                            alpha: .4,
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          size: 18,
                                          color: context.textColor.withValues(
                                            alpha: .4,
                                          ),
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
                  Gap(20),
                  GlassmorphicCard(
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
                                isMandatory: false,
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
                  Gap(20),
                  "New wallets will be synced across all your data in the app."
                      .toBody2(textAlign: .center),
                ],
              ),
            ),
            Padding(
              padding: .symmetric(horizontal: 12),
              child: Container(
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      "007eff".toColor(),
                      "008fff".toColor(),
                      "00a7ff".toColor(),
                      "00c0ff".toColor(),
                    ],
                    begin: .centerLeft,
                    end: .centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SafeArea(top: false, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
