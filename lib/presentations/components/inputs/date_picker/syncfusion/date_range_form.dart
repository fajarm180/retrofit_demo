import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SfDateRangeForm extends FormField<DateTimeRange?> {
  SfDateRangeForm({
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
    ValueChanged<DateTimeRange?>? onChanged,
    this.required = false,
    DateTime? firstDate,
    DateTime? lastDate,
    String Function(DateTimeRange? v)? displayFormat,
    SelectableDayPredicate? selectableDayPredicate,
  }) : super(builder: (state) {
          void onChangedHandler(DateTimeRange? value) {
            state.didChange(value);
            onChanged?.call(value);
          }

          void selectDate() async {
            final result = await showDialog<PickerDateRange?>(
              context: state.context,
              builder: (c) {
                return Dialog(
                  child: SizedBox(
                    height: MediaQuery.of(c).size.height / 3,
                    child: SfDateRangePicker(
                      initialSelectedRange: PickerDateRange(
                        state.value?.start,
                        state.value?.end,
                      ),
                      selectionMode: DateRangePickerSelectionMode.range,
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

            if (result?.startDate != null) {
              onChangedHandler(DateTimeRange(
                start: result!.startDate!,
                end: result.endDate ?? result.startDate!,
              ));
            }
          }

          String? formatDate(DateTimeRange? value) {
            if (value == null) return null;

            if (displayFormat != null) {
              return displayFormat(value);
            }

            return '${value.start.toString().split(' ')[0]} - ${value.end.toString().split(' ')[0]}';
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
  FormFieldValidator<DateTimeRange?>? get validator => (value) {
        if (required && (value == null)) {
          return requiredErrorText ?? 'This field cannot be empty';
        }

        return super.validator?.call(value);
      };
}
