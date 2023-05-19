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

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const headerSize = 20.0;
    const paragraphSize = 18.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          const Text('About', style: TextStyle(fontSize: 24.0)),
          const SizedBox(
            height: 8.0,
          ),
          RichText(
            text: TextSpan(
                text:
                    'The Text Image Appbar is the static verions of Text Image Sliver Appbar.'
                    ' The static version is preferred when ScrollView use scrollbars, for example if the platform is Windows, Linux or MacOS.'
                    ' The reason of this is because NestedScrollView does not work probably with scrollbars and it feels unnatural.'
                    '\n\n',
                style: const TextStyle(
                    color: Colors.black, fontSize: paragraphSize),
                children: [
                  TextSpan(
                      text: 'Material 3',
                      style: TextStyle(
                          color: theme.primaryColor, fontSize: headerSize)),
                  const TextSpan(
                      text: '\n'
                          'The scaffold does not support elevation with the appbar with Material 3.')
                ]),
          ),
        ]),
      ),
    );
  }
}
