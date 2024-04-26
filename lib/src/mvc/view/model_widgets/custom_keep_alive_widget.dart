import 'package:flutter/material.dart';

class CustomKeepAliveWidget extends StatefulWidget {
  const CustomKeepAliveWidget({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<CustomKeepAliveWidget> createState() => _CustomKeepAliveWidgetState();
}

class _CustomKeepAliveWidgetState extends State<CustomKeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
