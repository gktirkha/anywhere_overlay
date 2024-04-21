import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'anywhere_overlay.dart';

class AnywhereOverlayBase extends StatefulWidget {
  const AnywhereOverlayBase({
    super.key,
    this.barrierDismissible = true,
    this.completer,
    required this.child,
    required this.showAnimation,
    this.alignment = Alignment.center,
  });
  final bool barrierDismissible;
  final Completer<void>? completer;
  final Widget child;
  final bool showAnimation;
  final AlignmentGeometry alignment;

  @override
  State<AnywhereOverlayBase> createState() => AnywhereOverlayBaseState();
}

class AnywhereOverlayBaseState extends State<AnywhereOverlayBase>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late bool _dismissible;
  late Color _bgColor;
  late bool _ignoring;
  bool get hasPersistentCallbacks =>
      SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _dismissible = widget.barrierDismissible;
    _bgColor = AnyWhereOverlay.instance.overlayBgColor;
    _ignoring = !widget.barrierDismissible;

    _controller = AnimationController(
      vsync: this,
      duration: AnyWhereOverlay.instance.animationDuration,
    )..addStatusListener(
        (status) {
          bool isCompleted = widget.completer?.isCompleted ?? false;
          if (status == AnimationStatus.completed && !isCompleted) {
            widget.completer?.complete();
          }
        },
      );

    _show(widget.showAnimation);
  }

  Future<void> _show(bool showAnimation) {
    if (hasPersistentCallbacks) {
      Completer completer = Completer<void>();
      completer.complete(_controller.forward(from: showAnimation ? 0 : 1));
      return completer.future;
    }
    return _controller.forward(from: showAnimation ? 0 : 1);
  }

  Future<void> hide(bool showAnimation) {
    if (hasPersistentCallbacks) {
      Completer completer = Completer<void>();
      completer.complete(_controller.reverse(from: showAnimation ? 1 : 0));
      return completer.future;
    }
    return _controller.reverse(from: showAnimation ? 1 : 0);
  }

  Future<void> _onDismiss() async {
    return await AnyWhereOverlay.dismiss();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: widget.alignment,
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _controller.value,
              child: IgnorePointer(
                ignoring: _ignoring,
                child: _dismissible
                    ? GestureDetector(
                        onTap: _onDismiss,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          color: _bgColor,
                        ),
                      )
                    : Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        color: _bgColor,
                      ),
              ),
            );
          },
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return widget.child;
          },
        ),
      ],
    );
  }
}
