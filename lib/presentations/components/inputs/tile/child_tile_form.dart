import 'dart:io';

import 'package:flutter/material.dart';

class XChildTileForm<T> extends FormField<T?> {
  XChildTileForm({
    super.key,
    super.enabled,
    super.initialValue,
    super.forceErrorText,
    super.onSaved,
    super.validator,
    this.required = false,
    this.requiredErrorText,
    // Tile properties
    ValueChanged<T?>? onChanged,
    bool showLeadingImage = false,
    String? imgPath,
    String? title,
    Widget? titleWidget,
    IconData? trailingIcon,
    Future<T?> Function()? onTap,
  }) : super(builder: (state) {
          final theme = Theme.of(state.context);
          final inputDecor = theme.inputDecorationTheme;
          final ts = DefaultTextStyle.of(state.context).style;

          final isPath = imgPath != null && imgPath.isNotEmpty;
          final isUri = (isPath) ? Uri.parse(imgPath).isAbsolute : false;
          final isExist = (isPath) ? File(imgPath).existsSync() : false;

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

          void onChangedHandler(T value) {
            state.didChange(value);
            onChanged?.call(value);
          }

          return ListTile(
            key: ValueKey(state.value ?? state.errorText),
            visualDensity: VisualDensity.compact,
            enabled: enabled,
            focusColor: inputDecor.focusColor,
            hoverColor: inputDecor.hoverColor,
            iconColor: (state.hasError)
                ? theme.colorScheme.error
                : inputDecor.iconColor,
            contentPadding: EdgeInsets.all(8.0),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 8),
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
                    : (state.value != null)
                        ? theme.colorScheme.primary
                        : null,
              ),
            ),
            onTap: (onTap != null)
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
  FormFieldValidator<T?>? get validator => (value) {
        if (required && value == null) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
