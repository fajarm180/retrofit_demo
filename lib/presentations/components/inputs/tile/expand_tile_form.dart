import 'dart:io';

import 'package:flutter/material.dart';

import 'child_tile_form.dart';

class XExpandTileForm<T> extends FormField<T> {
  XExpandTileForm({
    super.key,
    super.enabled,
    super.initialValue,
    super.forceErrorText,
    super.onSaved,
    super.validator,
    this.required = false,
    this.requiredErrorText,
    // Checkbox properties
    bool isSelected = false,
    ValueChanged<bool?>? onCheckChanged,
    // Tile properties
    ValueChanged<T>? onChanged,
    bool showLeadingImage = false,
    String? imgPath,
    String? title,
    Widget? titleWidget,
    Future<T> Function()? onTap,
    List<XChildTileForm> children = const [],
  }) : super(builder: (state) {
          final theme = Theme.of(state.context);
          final inputDecor = theme.inputDecorationTheme;
          final ts = DefaultTextStyle.of(state.context).style;
          final color = theme.colorScheme;

          final isPath = imgPath != null && imgPath.isNotEmpty;
          final isUri = (isPath) ? Uri.parse(imgPath).isAbsolute : false;
          final isExist = (isPath) ? File(imgPath).existsSync() : false;

          isSelected = required;

          final titleTile = required
              ? RichText(
                  text: TextSpan(
                    style: ts,
                    children: [
                      TextSpan(
                        text: title ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                )
              : Text(title ?? '', style: ts);

          Widget imgWidget = isUri
              ? Image.network(imgPath)
              : isExist
                  ? Image.file(File(imgPath))
                  : Icon(Icons.camera_alt);

          return ExpansionTile(
            maintainState: true,
            visualDensity: VisualDensity.compact,
            tilePadding: EdgeInsets.all(8.0).copyWith(right: 16),
            childrenPadding: EdgeInsets.only(left: 16),
            controlAffinity: ListTileControlAffinity.trailing,
            enabled: enabled,
            iconColor: inputDecor.iconColor,
            shape: LinearBorder(),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (v) => onCheckChanged?.call(v),
                ),
                if (showLeadingImage)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: color.primary),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imgWidget,
                  ),
              ],
            ),
            title: titleWidget ?? titleTile,
            subtitle: (state.hasError)
                ? Text(
                    state.errorText ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  )
                : null,
            initiallyExpanded: required,
            children: children,
          );
        });

  final String? requiredErrorText;
  final bool required;

  @override
  FormFieldValidator<T>? get validator => (value) {
        if (required && value == null) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
