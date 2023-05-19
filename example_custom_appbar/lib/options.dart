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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class Options {
  bool showImage;
  double imageHeight;
  bool showTitle;
  bool showBottom;
  bool showActionButtons;
  bool imageBehindAppbarStatus;
  Color? backgroundColor;
  Color? backgroundColorScrolledUnder;
  double elevation;
  double elevationScrolledUnder;

  Options({
    this.showImage = true,
    this.imageHeight = 100.0,
    this.showTitle = true,
    this.showBottom = true,
    this.showActionButtons = true,
    this.imageBehindAppbarStatus = false,
    this.backgroundColor = Colors.white,
    this.backgroundColorScrolledUnder =
        const Color.fromARGB(255, 236, 247, 251),
    this.elevation = 0.0,
    this.elevationScrolledUnder = 1.0,
  });
}

class OptionsCard extends StatelessWidget {
  final Options options;
  final double minImageHeight;
  final double maxImageHeight;
  final VoidCallback onChange;

  const OptionsCard(
      {super.key,
      required this.options,
      required this.onChange,
      required this.minImageHeight,
      required this.maxImageHeight});

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                    child: Text(
                  'Options',
                  style: TextStyle(fontSize: 20.0),
                )),
                const Divider(),
                CheckboxListTile(
                    title: const Text('Show Image'),
                    value: options.showImage,
                    onChanged: onChangeShowImage),
                const Text('Image height:'),
                Slider(
                  onChanged: options.showImage ? onChangeHeight : null,
                  value: options.imageHeight,
                  min: minImageHeight,
                  max: maxImageHeight,
                ),
                CheckboxListTile(
                    enabled: options.showImage,
                    title: const Text('Image behind appbar status:'),
                    value: options.imageBehindAppbarStatus,
                    onChanged: onChangeBehindAppbarStatus),
                CheckboxListTile(
                    title: const Text('Show Title'),
                    value: options.showTitle,
                    onChanged: onChangeShowTitle),
                CheckboxListTile(
                    title: const Text('Show Action Buttons'),
                    value: options.showActionButtons,
                    onChanged: onChangeShowActionButtons),
                CheckboxListTile(
                    title: const Text('Show Bottom'),
                    value: options.showBottom,
                    onChanged: onChangeShowBottom),
              ],
            )));
  }

  onChangeShowImage(bool? value) {
    options.showImage = value ?? true;
    onChange();
  }

  onChangeHeight(double? value) {
    options.imageHeight = value ?? (minImageHeight + maxImageHeight) / 2.0;
    onChange();
  }

  onChangeBehindAppbarStatus(bool? value) {
    options.imageBehindAppbarStatus = value ?? false;
    onChange();
  }

  onChangeShowTitle(bool? value) {
    options.showTitle = value ?? true;
    onChange();
  }

  onChangeShowBottom(bool? value) {
    options.showBottom = value ?? true;
    onChange();
  }

  onChangeShowActionButtons(bool? value) {
    options.showActionButtons = value ?? true;
    onChange();
  }
}
