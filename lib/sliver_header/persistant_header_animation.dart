// Copyright (C) 2023 Joan Schipper
// 
// This file is part of custom_sliver_appbar.
// 
// custom_sliver_appbar is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// custom_sliver_appbar is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with custom_sliver_appbar.  If not, see <http://www.gnu.org/licenses/>.

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
