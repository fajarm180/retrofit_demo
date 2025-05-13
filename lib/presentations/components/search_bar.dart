import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class XSearchBar extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final Function(String v)? onSearch;
  final Function(String v)? onChanged;
  final String? placeholder;
  final Widget? suffixIcon;

  const XSearchBar({
    super.key,
    this.controller,
    this.onSearch,
    this.onChanged,
    this.placeholder,
    this.label,
    this.hintText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final tec = controller ?? TextEditingController();

    return Column(
      children: [
        TextField(
          controller: tec,
          textInputAction: TextInputAction.search,
          onSubmitted: (v) {
            if (v.isEmpty) return;
            FocusManager.instance.primaryFocus?.unfocus();

            if (onSearch != null) onSearch!(v);
          },
          onChanged: onChanged,
          decoration: InputDecoration(
            label: Text(label ?? 'Search'),
            suffixIcon: suffixIcon ??
                IconButton(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  onPressed:
                      (onSearch != null) ? () => onSearch!(tec.text) : null,
                  icon: const Icon(Icons.search),
                ),
            hintText: (placeholder ?? ''),
          ),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const Gap(8),
      ],
    );
  }
}
