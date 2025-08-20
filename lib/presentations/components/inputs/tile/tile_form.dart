import 'dart:io';

import 'package:flutter/material.dart';

class XTileForm extends FormField<String?> {
  XTileForm({
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
    ValueChanged<String?>? onChanged,
    bool showLeadingImage = false,
    String? imgPath,
    String? title,
    Widget? titleWidget,
    IconData? trailingIcon,
    Future<String?> Function()? onTap,
  }) : super(builder: (state) {
          final theme = Theme.of(state.context);
          final ts = DefaultTextStyle.of(state.context).style;

          final isPath = state.value != null && state.value!.isNotEmpty;
          final isUri = (isPath) ? Uri.parse(state.value!).isAbsolute : false;
          final isExist = (isPath) ? File(state.value!).existsSync() : false;

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
              ? Image.network(state.value!)
              : isExist
                  ? Image.file(File(state.value!))
                  : Icon(Icons.camera_alt);

          void onChangedHandler(String? value) {
            state.didChange(value);
            onChanged?.call(value);
            onCheckChanged?.call(state.validate());
            isSelected = true;
          }

          return ListTile(
            key: ValueKey(state.value ?? state.errorText),
            visualDensity: VisualDensity.compact,
            enabled: enabled,
            focusColor: theme.inputDecorationTheme.focusColor,
            hoverColor: theme.inputDecorationTheme.hoverColor,
            iconColor: theme.inputDecorationTheme.iconColor,
            contentPadding: EdgeInsets.all(8.0),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!required)
                  Checkbox(
                    value: isSelected,
                    isError: state.hasError,
                    onChanged: (onCheckChanged != null && enabled)
                        ? (v) => onCheckChanged.call(v)
                        : null,
                  ),
                if (showLeadingImage)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.primary),
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
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                trailingIcon ?? Icons.camera_alt,
                color: (state.hasError)
                    ? theme.colorScheme.error
                    : ((state.value ?? '').isNotEmpty)
                        ? theme.colorScheme.primary
                        : null,
              ),
            ),
            onTap: (onTap != null && enabled)
                ? () async {
                    final res = await onTap.call();
                    if (res != null) onChangedHandler(res);
                  }
                : null,
          );
        });

  final String? requiredErrorText;
  final bool required;

  @override
  FormFieldValidator<String?>? get validator => (value) {
        if (required && (value ?? '').isEmpty) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
