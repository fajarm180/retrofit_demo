import 'package:flutter/material.dart';

class ChildTileForm<T> extends FormField<T> {
  ChildTileForm({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled = true,
    this.required = false,
    this.requiredErrorText,
    String? title,
    Widget? titleWidget,
    Widget? trailing,
    Widget? divider,
    Future<T> Function()? onTap,
    ValueChanged<T>? onChanged,
    ValueChanged<String>? onError,
  }) : super(builder: (state) {
          final theme = Theme.of(state.context);
          final errorColor = theme.colorScheme.error;
          final ts = DefaultTextStyle.of(state.context).style;

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

          return ListTile(
            key: ValueKey(state.value ?? state.errorText),
            // onTap: null,
            dense: true,
            leading: Icon(Icons.circle, size: 8),
            title: titleWidget ?? titleTile,
            subtitle: (state.hasError)
                ? Text(
                    state.errorText!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: errorColor,
                    ),
                  )
                : null,
            trailing: trailing,
            iconColor: (state.hasError) ? errorColor : null,
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
