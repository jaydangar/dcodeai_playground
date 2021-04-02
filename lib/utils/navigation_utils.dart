import 'package:flutter/material.dart';

class NavigationUtils {
  BuildContext context;

  NavigationUtils(this.context) {
    removeSnackBarCallsBeforeNavigation();
  }

  void navigateToPage(String pageName) {
    Navigator.pushNamed(context, pageName);
  }

  void navigateToPageAndPopCurrentPage(String pageName, {dynamic args}) {
    Navigator.pushReplacementNamed(context, pageName, arguments: args);
  }

  void navigateToPageAndPopAllPages(String pageName) {
    Navigator.pushNamedAndRemoveUntil(
        context, pageName, ModalRoute.withName(pageName));
  }

  void navigateToPageWithArguments(String pageName, dynamic args) {
    Navigator.pushNamed(context, pageName, arguments: args);
  }

  void popCurrentPage({dynamic args}) {
    Navigator.pop(context,args);
  }

  void removeSnackBarCallsBeforeNavigation() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
