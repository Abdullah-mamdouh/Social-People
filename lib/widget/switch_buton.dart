
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/utils/theme_mode/theme.dart';
import 'package:sm/utils/theme_mode/theme.dart';

import '../constant/Constantcolors.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConstantColors constantColors = ConstantColors();
    final themeHeper = Provider.of<ThemeColor>(context);
    return Container(
      width: 50,height: 45,
      child: Switch.adaptive(
          value: themeHeper.isDarkMode,
          activeColor:constantColors.blueColor,
          inactiveThumbColor: Colors.blueGrey,
          onChanged: (value) {
            final provider = Provider.of<ThemeColor>(context, listen: false);
            provider.toggleTheme(value);
          },
        ),

    );
  }
}
