import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

export 'package:pull_to_refresh/pull_to_refresh.dart';

class XListView extends StatelessWidget {
  final RefreshController refreshController;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final int itemsCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final Widget? onEmptyDisplay;
  final bool? isEmpty;

  const XListView({
    super.key,
    required this.refreshController,
    this.onRefresh,
    this.onLoading,
    required this.itemsCount,
    required this.itemBuilder,
    this.onEmptyDisplay,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: onRefresh,
      onLoading: onLoading,
      header: const WaterDropMaterialHeader(),
      child: (isEmpty ?? false)
          ? Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: kToolbarHeight),
              child: SingleChildScrollView(
                child: onEmptyDisplay ?? Container(),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: itemsCount,
              itemBuilder: itemBuilder,
            ),
    );
  }
}
