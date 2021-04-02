import 'package:flutter/material.dart';

class MediaQueryUtils {
  final BuildContext context;

  MediaQueryUtils(this.context);

  //  fetch size of the screen
  Size getSize() {
    return MediaQuery.of(context).size;
  }

  //  fetch height of the screen
  double get height {
    return MediaQuery.of(context).size.height;
  }

  double get width {
    return MediaQuery.of(context).size.width;
  }

  double get aspectRatio {
    return MediaQuery.of(context).size.aspectRatio;
  }

  double get scaleFactor {
    return MediaQuery.of(context).textScaleFactor;
  }

}
