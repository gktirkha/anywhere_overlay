import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnywhereOverlayEntry extends OverlayEntry {
  AnywhereOverlayEntry({required super.builder});

  @override
  void markNeedsBuild() {
    super.markNeedsBuild();

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          super.markNeedsBuild();
        },
      );
    } else {
      super.markNeedsBuild();
    }
  }
}
