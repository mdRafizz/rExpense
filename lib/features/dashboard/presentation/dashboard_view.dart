import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:r_expense/core/extensions/context_extension.dart';
import 'package:r_expense/core/extensions/extensions.dart';
import 'package:r_expense/features/income/presentation/add_income_view.dart';
import 'package:r_expense/features/wallet/presentation/add_wallet_view.dart';


class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.cardColor,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Padding(
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
                          color: context.cardColor,
                        ),
                        alignment: .center,
                        child: "bell".toSvgIcon(color: context.textColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                padding: .symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                alignment: .center,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddIncomeView(),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.buttonGreenColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            // border: Border.all(width: .5,color: context.dividerColor)
                          ),
                          alignment: .center,
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              "addIncome".toSvgIcon(color: Colors.white),
                              Gap(10),
                              "Income".toSubtitle2(color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gap(20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddWalletView(),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: context.buttonRedColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          alignment: .center,
                          child: Row(
                            mainAxisAlignment: .center,
                            children: [
                              "addExpense".toSvgIcon(color: Colors.white),
                              Gap(10),
                              "Expense".toSubtitle2(color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
