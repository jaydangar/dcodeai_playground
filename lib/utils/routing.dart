import 'package:dcodeai_playground/pages/cv_ide_page.dart';
import 'package:dcodeai_playground/pages/cv_rgb_ide_page.dart';
import 'package:dcodeai_playground/pages/matplotlib_ide_page.dart';
import 'package:dcodeai_playground/pages/nltk_ide_page.dart';
import 'package:dcodeai_playground/pages/text_ide_page.dart';
import 'package:dcodeai_playground/widgets/safe_area_widget.dart';
import 'package:flutter/material.dart';

import 'colors_utils.dart';

class Routing {
  static const String ComputerVisionIDEPageRoute = '/computerVisionIDEPage';
  static const String ComputerVisionRGBIDEPageRoute =
      '/computerVisionRGBIDEPage';
  static const String TextIDEPageRoute = '/textIDEPage';
  static const String NLTKIDEPageRoute = '/nltkIDEPage';
  static const String MatplotIDEPageRoute = '/matplotlibIDEPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MatplotIDEPageRoute:
        return MaterialPageRoute(
          builder: (context) => SafeAreaWidget(
            backgroundColor: ColorsUtils.appbar_background_color,
            child: MatplotlibIDEPage(),
          ),
        );
      case TextIDEPageRoute:
        return MaterialPageRoute(
          builder: (context) => SafeAreaWidget(
            backgroundColor: ColorsUtils.appbar_background_color,
            child: TextIDEPage(),
          ),
        );
      case NLTKIDEPageRoute:
        return MaterialPageRoute(
          builder: (context) => SafeAreaWidget(
            backgroundColor: ColorsUtils.appbar_background_color,
            child: NLTKIDEPage(),
          ),
        );
      case ComputerVisionIDEPageRoute:
        return MaterialPageRoute(
          builder: (context) => SafeAreaWidget(
            backgroundColor: ColorsUtils.appbar_background_color,
            child: CVIDEPage(),
          ),
        );
      case ComputerVisionRGBIDEPageRoute:
        return MaterialPageRoute(
          builder: (context) => SafeAreaWidget(
            backgroundColor: ColorsUtils.appbar_background_color,
            child: CVRGBIDEPage(),
          ),
        );
    }
  }
}
