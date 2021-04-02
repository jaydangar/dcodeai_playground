import 'package:dcodeai_playground/pages/cv_ide_page.dart';
import 'package:dcodeai_playground/pages/cv_rgb_ide_page.dart';
import 'package:dcodeai_playground/pages/matplotlib_ide_page.dart';
import 'package:dcodeai_playground/pages/nltk_ide_page.dart';
import 'package:dcodeai_playground/pages/text_ide_page.dart';
import 'package:flutter/material.dart';

class PageDecider {
  static const textbasedIDEPage = 'textIDEPage';
  static const matplotlibbasedIDEPage = 'matplotlibIDEPage';
  static const cvbasedIDEPage = 'cvIDEPage';
  static const cvRGBbasedIDEPage = 'cvRGBIDEPage';
  static const nltkbasedIDEPage = 'nltkIDEPage';

  static Widget returnPage(String pageName) {
    switch (pageName) {
      case matplotlibbasedIDEPage:
        return MatplotlibIDEPage();
      case cvbasedIDEPage:
        return CVIDEPage();
      case cvRGBbasedIDEPage:
        return CVRGBIDEPage();
      case nltkbasedIDEPage:
        return NLTKIDEPage();
      default:
        return TextIDEPage();
    }
  }
}
