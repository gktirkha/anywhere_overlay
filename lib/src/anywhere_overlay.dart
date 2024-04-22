import 'dart:async';

import 'package:flutter/material.dart';

import 'anywhere_overlay_base.dart';
import 'anywhere_overlay_entry.dart';
import 'anywhere_overlay_wrapper.dart';

/// A utility class for displaying overlays anywhere on the screen in a Flutter application.
///
/// The [AnyWhereOverlay] class provides methods to show and dismiss overlays with customizable
/// animation duration, overlay background color, and alignment.
class AnyWhereOverlay {
  AnyWhereOverlay._private();

  /// Singleton instance of [AnyWhereOverlay].
  static final AnyWhereOverlay _instance = AnyWhereOverlay._private();

  /// Returns the singleton instance of [AnyWhereOverlay].
  static AnyWhereOverlay get instance => _instance;

  /// The entry point for the overlay widget.
  AnywhereOverlayEntry? overlayEntry;

  /// The widget to be displayed as the top overlay.
  Widget? _topOverlayWidget;

  /// Returns the widget to be displayed as the top overlay.
  Widget? get topOverlayWidget => _topOverlayWidget;

  /// The duration of the animation when showing or dismissing overlays.
  late Duration animationDuration;

  /// The background color of the overlay.
  late Color overlayBgColor;

  /// The alignment of the overlay on the screen.
  late AlignmentGeometry alignment;

  /// The key to access the state of the overlay widget.
  GlobalKey<AnywhereOverlayBaseState>? _key;

  /// Initializes the [AnyWhereOverlay] with custom configurations.
  ///
  /// Returns a [TransitionBuilder] that wraps the provided [builder] with the overlay.
  ///
  /// By default, the overlay background color is set to 70% opacity black and the alignment
  /// is set to center.
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

  /// Dismisses the top overlay.
  ///
  /// If [animate] is true or null, the dismissal is animated; otherwise, it's immediate.
  static Future<void> dismiss({bool? animate}) {
    return _instance._dismiss(animate ?? _instance.topOverlayWidget == null);
  }

  /// Internal method to dismiss the top overlay.
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

  /// Resets the top overlay and rebuilds the overlay entry.
  void _resetTopOverlay() {
    _instance._topOverlayWidget = null;
    _key = null;
    _rebuildOverlay();
  }

  /// Rebuilds the overlay entry to reflect changes.
  void _rebuildOverlay() {
    overlayEntry?.markNeedsBuild();
  }

  /// Configures the overlay with custom animation duration, background color, and alignment.
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

  /// Shows an overlay with the provided child widget.
  ///
  /// If [barrierDismissible] is true, tapping outside the overlay dismisses it.
  static void show({
    bool barrierDismissible = false,
    required Widget child,
  }) {
    _instance._show(
      barrierDismissible: barrierDismissible,
      child: child,
    );
  }

  /// Internal method to show the overlay.
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
