import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../extensions/context_extension.dart';
import '../extensions/string_extensions.dart';
import '../theme/text_styles.dart';

class CustomLabeledTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? minLines;
  final TextAlignVertical textAlignVertical;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isMandatory;
  final double? textFieldHeight;

  const CustomLabeledTextField({
    super.key,
    required this.label,
    this.hintText = "Enter text",
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.minLines = 1,
    this.textAlignVertical = TextAlignVertical.center,
    this.controller,
    this.onChanged,
    this.isMandatory = true,
    this.textFieldHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        isMandatory? label.toMandatoryLabel(context): label.toSubtitle2(),
        const Gap(8),
        SizedBox(
          height: textFieldHeight,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            minLines: minLines,
            maxLines: maxLines,
            textAlignVertical: textAlignVertical,
            keyboardType: keyboardType,
            style: TextStyles.regular(
              color: context.textColor,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: context.scaffoldColor,
              hintText: hintText,
              hintStyle: TextStyles.regular(
                color: context.dividerColor,
                fontSize: 12,
              ),
              contentPadding: const .all(12),
              border: OutlineInputBorder(
                borderRadius: .circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}