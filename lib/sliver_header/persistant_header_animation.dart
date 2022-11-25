import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class PersistantHeaderAnimation extends Animation<double>
    with AnimationLocalListenersMixin, AnimationLocalStatusListenersMixin {
  double _shrinkOffset = 0.0;
  double delta;
  double start;

  PersistantHeaderAnimation({
    required this.delta,
    required this.start,
    double shrinkOffset = 0.0,
  }) : _shrinkOffset = shrinkOffset;

  set shrinkOffset(value) {
    if (value != _shrinkOffset) {
      _shrinkOffset = value;
      notifyListeners();
    }
  }

  void notifyListenersAnyway() {
    notifyListeners();
  }

  // @override
  // void addListener(VoidCallback listener) {
  //   super.addListener(listener);
  // }

  // @override
  // void removeListener(VoidCallback listener) {
  //   super.removeListener(listener);
  // }

  @override
  AnimationStatus get status {
    if (value == 0.0) {
      return AnimationStatus.dismissed;
    } else if (value == 1.0) {
      return AnimationStatus.completed;
    } else {
      return AnimationStatus.forward;
    }
  }

  @override
  double get value {
    double v = (_shrinkOffset - start) / delta;

    return clampDouble(v, 0.0, 1.0);
  }

  @override
  void didRegisterListener() {}

  @override
  void didUnregisterListener() {}
}
