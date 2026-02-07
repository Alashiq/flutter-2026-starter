import 'package:flutter/material.dart';

class AutoLoad extends StatefulWidget {
  final Future<void> Function() onLoad;
  final Widget Function(BuildContext context) builder;

  const AutoLoad({super.key, required this.onLoad, required this.builder});

  @override
  State<AutoLoad> createState() => _AutoLoadState();
}

class _AutoLoadState extends State<AutoLoad> {
  @override
  void initState() {
    super.initState();
    // استخدام addPostFrameCallback لضمان استدعاء الوظيفة بعد بناء الواجهة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
