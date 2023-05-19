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
                    ' The scrollExtent was defined as maxExtent instead of maxExtent - minExtent.'
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
