import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SfMultiDateForm extends FormField<List<DateTime>?> {
  SfMultiDateForm({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled = true,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    Widget? label,
    String? hintText,
    this.requiredErrorText,
    VoidCallback? onClear,
    ValueChanged<List<DateTime>?>? onChanged,
    this.required = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(DateTime? v)? displayFormat,
    bool Function(DateTime? v)? selectableDayPredicate,
  }) : super(builder: (state) {
          void onChangedHandler(List<DateTime>? value) {
            state.didChange(value);
            onChanged?.call(value);
          }

          void selectDate() async {
            final result = await showDialog<List<DateTime>?>(
              context: state.context,
              builder: (c) {
                return Dialog(
                  child: SizedBox(
                    height: MediaQuery.of(c).size.height / 3,
                    child: SfDateRangePicker(
                      initialSelectedDates: state.value,
                      selectionMode: DateRangePickerSelectionMode.multiple,
                      showActionButtons: true,
                      onSubmit: (v) => Navigator.pop(c, v),
                      onCancel: () => Navigator.pop(c),
                      minDate: firstDate,
                      maxDate: lastDate,
                      selectableDayPredicate: selectableDayPredicate?.call,
                    ),
                  ),
                );
              },
            );

            if (result != null) {
              onChangedHandler(result);
            }
          }

          String? formatDate(List<DateTime>? value) {
            if (value == null) return null;

            final f =
                displayFormat ?? (DateTime? v) => v.toString().split(' ')[0];

            return value.map(f).join(', \n');
          }

          return TextFormField(
            key: ValueKey(state.value ?? state.errorText),
            initialValue: formatDate(state.value),
            autovalidateMode: autovalidateMode,
            onSaved: (v) => onSaved?.call(state.value),
            onChanged: (v) => onChanged?.call(state.value),
            onTap: selectDate,
            readOnly: true,
            forceErrorText: (state.hasError) ? state.errorText : null,
            maxLines: state.value?.length ?? 1,
            decoration: InputDecoration(
              label: label,
              hintText: hintText ?? '',
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.value != null && enabled)
                      InkWell(
                        onTap: onClear ?? () => onChangedHandler(null),
                        child: const Icon(Icons.clear),
                      ),
                    const Icon(Icons.calendar_month),
                  ],
                ),
              ),
              enabled: enabled,
            ),
          );
        });

  final String? requiredErrorText;
  final bool required;

  @override
  FormFieldValidator<List<DateTime>?>? get validator => (value) {
        if (required && (value == null)) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
