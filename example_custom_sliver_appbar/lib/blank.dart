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

import 'package:flutter/material.dart';

class BlankCard extends StatelessWidget {
  final int index;
  final double radial;
  final Widget title;

  const BlankCard({
    super.key,
    required this.index,
    this.radial = 24.0,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = index % 2 != 0
        ? theme.colorScheme.surface
        : theme.colorScheme.surfaceTint;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radial),
          ),
          color: color,
          child: Center(
            child: title,
          )),
    );
  }
}
