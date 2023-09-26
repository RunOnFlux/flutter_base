//import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/interface_brightness.dart';

class WindowTitleBar extends StatelessWidget {
  final InterfaceBrightness brightness;
  const WindowTitleBar({Key? key, required this.brightness}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*Platform.isWindows
        ? Positioned(
            right: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 28.0,
              color: Colors.transparent,
              child: MoveWindow(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    MinimizeWindowButton(
                      colors: WindowButtonColors(
                        iconNormal: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        iconMouseDown: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        iconMouseOver: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        normal: Colors.transparent,
                        mouseOver: brightness == InterfaceBrightness.light
                            ? Colors.black.withOpacity(0.04)
                            : Colors.white.withOpacity(0.04),
                        mouseDown: brightness == InterfaceBrightness.light
                            ? Colors.black.withOpacity(0.08)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    MaximizeWindowButton(
                      colors: WindowButtonColors(
                        iconNormal: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        iconMouseDown: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        iconMouseOver: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        normal: Colors.transparent,
                        mouseOver: brightness == InterfaceBrightness.light
                            ? Colors.black.withOpacity(0.04)
                            : Colors.white.withOpacity(0.04),
                        mouseDown: brightness == InterfaceBrightness.light
                            ? Colors.black.withOpacity(0.08)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    CloseWindowButton(
                      onPressed: () {
                        appWindow.close();
                      },
                      colors: WindowButtonColors(
                        iconNormal: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        iconMouseDown: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        iconMouseOver: brightness == InterfaceBrightness.light ? Colors.black : Colors.white,
                        normal: Colors.transparent,
                        mouseOver: brightness == InterfaceBrightness.light
                            ? Colors.black.withOpacity(0.04)
                            : Colors.white.withOpacity(0.04),
                        mouseDown: brightness == InterfaceBrightness.light
                            ? Colors.black.withOpacity(0.08)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        :*/
        Container();
  }
}
