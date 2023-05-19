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
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:flutter/material.dart';

class Options {
  double _minCenter;
  double _maxCenter;
  double bottomHeigth;
  double floatingExtent;
  LrTbFit lrTbFit;
  bool imageBehindStatusbar;
  bool blockTabScroll;

  Options({
    required double minExtent,
    required double maxExtent,
    required this.floatingExtent,
    required this.lrTbFit,
    required this.bottomHeigth,
    this.imageBehindStatusbar = true,
    this.blockTabScroll = false,
  })  : _minCenter = minExtent,
        _maxCenter = maxExtent;

  double get minExtent => _minCenter;

  set minExtent(double value) {
    _minCenter = value;
    if (_minCenter > floatingExtent) {
      floatingExtent = value;
    }
  }

  double get maxExtent => _maxCenter + bottomHeigth;

  set maxExtent(double value) {
    _maxCenter = value - bottomHeigth;

    if (_maxCenter + bottomHeigth < floatingExtent) {
      floatingExtent = _maxCenter;
    }
    if (_maxCenter < _minCenter) {
      _minCenter = _maxCenter;
    }
  }

  void checkAvailableHeight(double available) {
    if (floatingExtent > available) {
      floatingExtent = available;
    }

    if (_maxCenter + bottomHeigth > available) {
      _maxCenter = available - bottomHeigth;
    }
  }
}

class OptionsCardPortrait extends StatefulWidget {
  final Options options;
  final VoidCallback onChange;

  const OptionsCardPortrait(
      {super.key, required this.options, required this.onChange});

  @override
  State<OptionsCardPortrait> createState() => _OptionsCardPortraitState();
}

class _OptionsCardPortraitState extends State<OptionsCardPortrait> {
  late Options options = widget.options;

  @override
  void didUpdateWidget(covariant OptionsCardPortrait oldWidget) {
    if (options != widget.options) {
      setState(() {
        options = widget.options;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height = MediaQuery.of(context).size.height;
    final double avaliableHeight =
        height > 0.0 ? (height / 3 * 2).roundToDouble() : 0.0;

    //Why a first build without a height and only in profile mode?
    if (height < 56.0) {
      return const SizedBox.shrink();
    }
    options.checkAvailableHeight(avaliableHeight);

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text('Options', style: theme.textTheme.headlineSmall)),
              const Divider(),
              const Text(
                'Minimum',
              ),
              if (options.maxExtent >= 1.0)
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                          min: 0.0,
                          divisions: options.maxExtent.toInt(),
                          max: options.maxExtent,
                          value: options.minExtent,
                          onChanged: minExtentOnChange,
                          onChangeEnd: minExtentOnChange),
                    ),
                    SizedBox(
                        width: 30,
                        child: Text(
                          '${options.minExtent.toInt()}',
                          textAlign: TextAlign.end,
                        ))
                  ],
                ),
              Row(children: [
                const SizedBox(
                  width: 24.0,
                ),
                const Text('Typical:'),
                const SizedBox(
                  width: 8.0,
                ),
                TextButton(
                    onPressed: () => minExtentOnChange(options.bottomHeigth),
                    child: Text('bottom: ${options.bottomHeigth}')),
                TextButton(
                    onPressed: () =>
                        minExtentOnChange(56.0 + options.bottomHeigth),
                    child: Text('bar + bottom: 56.0+${options.bottomHeigth}'))
              ]),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                'Maximum',
              ),
              if (56.0 + 1.0 <= avaliableHeight)
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                          min: 56.0,
                          max: avaliableHeight,
                          divisions: (avaliableHeight - 56.0).toInt(),
                          value: options.maxExtent,
                          onChanged: maxExtentOnChange,
                          onChangeEnd: maxExtentOnChange),
                    ),
                    SizedBox(
                        width: 30,
                        child: Text(
                          '${options.maxExtent.toInt()}',
                          textAlign: TextAlign.end,
                        ))
                  ],
                ),
              Row(children: [
                const SizedBox(
                  width: 24.0,
                ),
                const Text('Typical:'),
                const SizedBox(
                  width: 8.0,
                ),
                TextButton(
                    onPressed: () => maxExtentOnChange(300.0),
                    child: const Text('300.0'))
              ]),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                'Floating',
              ),
              if (options.minExtent < options.maxExtent)
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                          min: options.minExtent,
                          max: options.maxExtent,
                          divisions:
                              (options.maxExtent - options.minExtent).toInt(),
                          value: options.floatingExtent,
                          onChanged: floatingExtentOnChange,
                          onChangeEnd: floatingExtentOnChange),
                    ),
                    SizedBox(
                        width: 30,
                        child: Text(
                          '${options.floatingExtent.toInt()}',
                          textAlign: TextAlign.end,
                        )),
                  ],
                ),
              Row(
                children: [
                  const SizedBox(
                    width: 24.0,
                  ),
                  const Text('Typical:'),
                  const SizedBox(
                    width: 8.0,
                  ),
                  TextButton(
                      onPressed: () => floatingExtentOnChange(
                          (options.lrTbFit == LrTbFit.no ? 104.0 : 48.0)),
                      child: Text(
                          '${(options.lrTbFit == LrTbFit.no ? 104.0 : 48.0)}')),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              CheckboxListTile(
                  title: const Text(
                    'Image behind appbar status:',
                  ),
                  value: options.imageBehindStatusbar,
                  onChanged: imageBehind),
              const SizedBox(
                height: 8.0,
              ),
              const Text(
                'Place action bottoms beside bottom',
              ),
              RadioListTile<LrTbFit>(
                  title: const Text('No'),
                  value: LrTbFit.no,
                  groupValue: options.lrTbFit,
                  onChanged: changeLrTbFit),
              RadioListTile<LrTbFit>(
                  title: const Text('Fit'),
                  value: LrTbFit.fit,
                  groupValue: options.lrTbFit,
                  onChanged: changeLrTbFit),
              RadioListTile<LrTbFit>(
                  title: const Text('Even'),
                  value: LrTbFit.even,
                  groupValue: options.lrTbFit,
                  onChanged: changeLrTbFit),
              Row(children: [
                const SizedBox(
                  width: 24.0,
                ),
                const Text('Typical:'),
                const SizedBox(
                  width: 8.0,
                ),
                TextButton(
                    onPressed: () {
                      options
                        ..minExtent = 0.0
                        ..floatingExtent = 48.0;
                      widget.onChange();
                    },
                    child: const Text('M:0, F:48')),
                TextButton(
                    onPressed: () {
                      options
                        ..minExtent = 56
                        ..floatingExtent = 56.0;
                      widget.onChange();
                    },
                    child: const Text('M:56, F:56')),
              ]),
              const SizedBox(
                height: 8.0,
              ),
              CheckboxListTile(
                  title: const Text(
                    'Block tab physics (scroll)',
                  ),
                  value: options.blockTabScroll,
                  onChanged: blockTabPhysics),
            ],
          ),
        ));
  }

  minExtentOnChange(double value) {
    options.minExtent = value;
    widget.onChange();
  }

  maxExtentOnChange(double value) {
    options.maxExtent = value;
    widget.onChange();
  }

  floatingExtentOnChange(double value) {
    options.floatingExtent = value;
    widget.onChange();
  }

  imageBehind(bool? value) {
    options.imageBehindStatusbar = value ?? false;
    widget.onChange();
  }

  changeLrTbFit(LrTbFit? value) {
    options.lrTbFit = value ?? LrTbFit.no;
    widget.onChange();
  }

  blockTabPhysics(bool? value) {
    options.blockTabScroll = value ?? false;
    widget.onChange();
  }
}
