import 'dart:async';

import 'package:flutter/material.dart';

import 'anywhere_overlay_base.dart';
import 'anywhere_overlay_entry.dart';
import 'anywhere_overlay_wrapper.dart';

class AnyWhereOverlay {
  AnyWhereOverlay._private();
  static final AnyWhereOverlay _instance = AnyWhereOverlay._private();
  static AnyWhereOverlay get instance => _instance;

  AnywhereOverlayEntry? overlayEntry;

  Widget? _topOverlayWidget;
  Widget? get topOverlayWidget => _topOverlayWidget;

  late Duration animationDuration;
  late Color overlayBgColor;
  late AlignmentGeometry alignment;

  GlobalKey<AnywhereOverlayBaseState>? _key;

  static TransitionBuilder init({
    TransitionBuilder? builder,
    Duration animationDuration = const Duration(milliseconds: 200),
    Color? overlayBgColor,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    configure(
      animationDuration: animationDuration,
      overlayBgColor: overlayBgColor ?? Colors.black.withOpacity(.70),
      alignment: alignment,
    );
    return (context, child) => builder != null
        ? builder(
            context,
            AnywhereOverlayWrapper(
              child: child,
            ),
          )
        : AnywhereOverlayWrapper(
            child: child,
          );
  }

  static Future<void> dismiss() {
    return _instance._dismiss(_instance.topOverlayWidget == null);
  }

  Future<void> _dismiss(bool showAnimation) async {
    if (_key != null && _key?.currentState == null) {
      _key?.currentState?.hide(showAnimation).whenComplete(() {
        _resetTopOverlay();
      });
      return;
    }

    return await _key?.currentState?.hide(showAnimation).whenComplete(() {
      _resetTopOverlay();
    });
  }

  void _resetTopOverlay() {
    _instance._topOverlayWidget = null;
    _key = null;
    _rebuildOverlay();
  }

  void _rebuildOverlay() {
    overlayEntry?.markNeedsBuild();
  }

  static void configure({
    Duration? animationDuration,
    Color? overlayBgColor,
    AlignmentGeometry? alignment,
  }) {
    if (animationDuration != null) {
      _instance.animationDuration = animationDuration;
    }

    if (overlayBgColor != null) {
      _instance.overlayBgColor = overlayBgColor;
    }

    if (alignment != null) {
      _instance.alignment = alignment;
    }
  }

  static void show({
    bool barrierDismissible = false,
    required Widget child,
  }) {
    _instance._show(
      barrierDismissible: barrierDismissible,
      child: child,
    );
  }

  void _show({
    required bool barrierDismissible,
    required Widget child,
  }) {
    if (_key != null) _dismiss(false);
    _key = GlobalKey<AnywhereOverlayBaseState>();
    Completer<void> completer = Completer<void>();
    _topOverlayWidget = AnywhereOverlayBase(
      barrierDismissible: barrierDismissible,
      completer: completer,
      key: _key,
      showAnimation: _topOverlayWidget == null,
      alignment: alignment,
      child: child,
    );
    _rebuildOverlay();
  }
}
