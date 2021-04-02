import 'package:dcodeai_playground/utils/colors_utils.dart';
import 'package:dcodeai_playground/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class CodeSnippetWidget extends StatelessWidget {
  const CodeSnippetWidget({
    Key key,
    @required this.code,
  }) : super(key: key);

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorsUtils.gray_outline_button_light,
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: 14 * MediaQueryUtils(context).scaleFactor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
