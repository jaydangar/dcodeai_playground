import 'package:flutter/material.dart';

import 'asset_utils.dart';
import 'mediaquery.dart';

class AlertDialogUtils {
  bool isShowing = false;

  Future<void> showAlertDialog(BuildContext context, {Widget widget}) async {
    isShowing = true;
    return await showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) {
        return widget ??
            Center(
              child: Image.asset(
                AssetUtils.loader,
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                height: MediaQueryUtils(context).height * 0.1,
                width: MediaQueryUtils(context).height * 0.1,
              ),
            );
      },
    );
  }

  bool get alertDialogStatus {
    return isShowing;
  }

  void dismissAlertDialog(BuildContext context) {
    if (isShowing) {
      isShowing = !isShowing;
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }
}
