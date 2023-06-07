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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const headerSize = 18.0;
    const paragraphSize = 18.0;

    bool noMobile = false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        {
          noMobile = true;
          break;
        }
      default:
        {
          noMobile = false;
        }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      color: theme.colorScheme.onPrimary,
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
                    'In 2019 I noticed a small deadzone during scrolling (#47039), after some digging I found out that it was only a small problem.'
                    ' It seemed that maxScrollObstructionExtent was not passed on to NestedScrollView caused by SliverPadding.'
                    ' Besides this small issue I wanted also more layout freedom for the appbar, for this reason a custom appbar delegate was made, with a new future floating extent.'
                    ' In this example the default delegate is shown: resizeble title and image below or under the statusbar with adjustable floating extend and the option to animated actions bar besides the bottom widget (tabbar). '
                    '\n\n',
                style: const TextStyle(
                    color: Colors.black, fontSize: paragraphSize),
                children: [
                  TextSpan(
                      text: 'Floating Extent',
                      style: TextStyle(
                          color: theme.primaryColor, fontSize: headerSize)),
                  const TextSpan(
                      text: '\n'
                          'If the phone is in landscape, the appbar can take a lot of space. Off course it is possible to disable pinned and use floating, nevertheless if the floating appbar is relative large, the change is not always subtle and can be annoying.'
                          ' For this reason floating extent is introduced, to show only the necessary action buttons and/or tabbar while scrolling. With the default delegate, it is also possible to animate the action buttons beside the tabbar to save even more space.'
                          ' If the user is scroll to the start the complete appbar is visible. If floating extent is equal to max extent, the behavior is equal to the default appBar'
                          '\n\n',
                      style: TextStyle(
                          color: Colors.black, fontSize: paragraphSize)),
                  if (noMobile)
                    TextSpan(
                        text: 'Options',
                        style: TextStyle(
                            color: theme.primaryColor, fontSize: headerSize)),
                  const TextSpan(
                      text: '\n'
                          'In the tab options, different options can be explored for portrait and landscape view.'
                          '\n\n'),
                  if (noMobile)
                    TextSpan(
                        text: 'Windows, MacOS or Linux',
                        style: TextStyle(
                            color: theme.primaryColor, fontSize: headerSize)),
                  if (noMobile)
                    const TextSpan(
                        text: '\n'
                            'Scrollbars is deactivated, because nestedscrollview does not work as intented with scrollbars. This is espected because NestedScrollView is normally used with android or iOS. Please use your left mouse button to simulate touch. The status bar is simulated :)')
                ]),
          ),
        ]),
      ),
    );
  }
}
