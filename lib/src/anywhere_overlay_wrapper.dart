import 'package:flutter/material.dart';

import 'anywhere_overlay.dart';
import 'anywhere_overlay_entry.dart';

class AnywhereOverlayWrapper extends StatefulWidget {
  const AnywhereOverlayWrapper({super.key, this.child});
  final Widget? child;

  @override
  State<AnywhereOverlayWrapper> createState() => _AnywhereOverlayWrapperState();
}

class _AnywhereOverlayWrapperState extends State<AnywhereOverlayWrapper> {
  late AnywhereOverlayEntry _anywhereOverlayEntry;

  @override
  void initState() {
    super.initState();
    _anywhereOverlayEntry = AnywhereOverlayEntry(
      builder: (context) =>
          AnyWhereOverlay.instance.topOverlayWidget ?? const SizedBox.shrink(),
    );
    AnyWhereOverlay.instance.overlayEntry = _anywhereOverlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          AnywhereOverlayEntry(
            builder: (context) => widget.child ?? const SizedBox.shrink(),
          ),
          _anywhereOverlayEntry
        ],
      ),
    );
  }
}
