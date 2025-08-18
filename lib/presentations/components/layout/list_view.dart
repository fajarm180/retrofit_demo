import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class XListView extends StatefulWidget {
  const XListView({
    required this.itemsCount,
    required this.itemBuilder,
    super.key,
    this.initialRefresh = true,
    this.onRefresh,
    this.onLoading,
    this.itemSeparator,
    this.onEmptyDisplay,
    this.padding,
    this.scrollDirection,
    this.reverse = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
  });

  final FutureOr<void> Function()? onRefresh;
  final Future<LoadStatus> Function()? onLoading;

  final int itemsCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final Widget Function(BuildContext context, int index)? itemSeparator;

  final Widget? onEmptyDisplay;
  final EdgeInsetsGeometry? padding;
  final Axis? scrollDirection;
  final bool initialRefresh;
  final bool reverse;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  State<XListView> createState() => _XListViewState();
}

class _XListViewState extends State<XListView> {
  late RefreshController rc;

  @override
  void initState() {
    rc = RefreshController(initialRefresh: widget.initialRefresh);
    super.initState();
  }

  void _onRefresh() async {
    try {
      await widget.onRefresh?.call();
      rc.refreshCompleted();
    } catch (e) {
      rc.refreshFailed();
    } finally {
      rc.resetNoData();
    }
  }

  void _onLoading() async {
    final result = await widget.onLoading?.call();

    switch (result) {
      case LoadStatus.idle:
        rc.loadComplete();
      case LoadStatus.failed:
        rc.loadFailed();
      case LoadStatus.noMore:
        rc.loadNoData();
      default:
        rc.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: rc,
      reverse: widget.reverse,
      enablePullUp: widget.itemsCount != 0,
      scrollDirection: widget.scrollDirection,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      child: (widget.itemsCount == 0)
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
              child: SingleChildScrollView(
                child: widget.onEmptyDisplay ?? Container(),
              ),
            )
          : (widget.itemSeparator != null)
              ? ListView.separated(
                  separatorBuilder: widget.itemSeparator!,
                  padding: widget.padding ?? EdgeInsets.zero,
                  itemCount: widget.itemsCount,
                  itemBuilder: widget.itemBuilder,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                )
              : ListView.builder(
                  padding: widget.padding ?? EdgeInsets.zero,
                  itemCount: widget.itemsCount,
                  itemBuilder: widget.itemBuilder,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                ),
    );
  }
}
