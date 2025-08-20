import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class XSearchBar extends StatefulWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final Function(String v)? onSearch;
  final Function(String v)? onChanged;
  final VoidCallback? onClear;
  final String? placeholder;
  final Widget? suffixIcon;

  const XSearchBar({
    super.key,
    this.controller,
    this.onSearch,
    this.onChanged,
    this.onClear,
    this.placeholder,
    this.label,
    this.hintText,
    this.suffixIcon,
  });

  @override
  State<XSearchBar> createState() => _XSearchBarState();
}

class _XSearchBarState extends State<XSearchBar> {
  @override
  void didChangeDependencies() {
    widget.controller?.clear();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final tec = widget.controller ?? TextEditingController();

    return Column(
      children: [
        TextField(
          controller: tec,
          textInputAction: TextInputAction.search,
          onSubmitted: (v) {
            if (v.isEmpty) return;
            FocusManager.instance.primaryFocus?.unfocus();

            if (widget.onSearch != null) widget.onSearch!(v);
          },
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            label: Text(widget.label ?? 'Search'),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tec.text.isNotEmpty)
                  InkWell(
                    onTap: widget.onClear ?? didChangeDependencies,
                    child: const Icon(Icons.clear),
                  ),
                widget.suffixIcon ??
                    IconButton(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      onPressed: (widget.onSearch != null)
                          ? () => widget.onSearch!(tec.text)
                          : null,
                      icon: const Icon(Icons.search),
                    ),
              ],
            ),
            hintText: (widget.placeholder ?? ''),
          ),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        const Gap(8),
      ],
    );
  }
}
