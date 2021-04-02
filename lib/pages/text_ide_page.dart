import 'package:dcodeai_playground/utils/alert_dialog_utils.dart';
import 'package:dcodeai_playground/utils/colors_utils.dart';
import 'package:dcodeai_playground/utils/const_utils.dart';
import 'package:dcodeai_playground/utils/mediaquery.dart';
import 'package:dcodeai_playground/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextIDEPage extends StatefulWidget {
  @override
  _TextIDEPageState createState() => _TextIDEPageState();
}

class _TextIDEPageState extends State<TextIDEPage> {
  MethodChannel _channel;

  TextEditingController _controller;
  ScrollController _scrollController;
  FocusNode _focusNode;

  String output = "";

  AlertDialogUtils _alertDialogUtils;
  Map<String, dynamic> data = Map();

  @override
  void initState() {
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _channel = MethodChannel('runPython');
    _alertDialogUtils = AlertDialogUtils();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> runPythonScript(String code) async {
    if (code.isEmpty) {
      ToastUtils.showToastMessage(text: ConstUtils.code_empty);
      return;
    }

    data.putIfAbsent("code", () => code);
    _alertDialogUtils.showAlertDialog(context);
    await Future.delayed(Duration(seconds: 1));
    dynamic result = await _channel.invokeMethod("runPythonScript", data);
    _alertDialogUtils.dismissAlertDialog(context);
    setState(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
      output = result["textOutput"] ??= "";
      data.clear();
    });
  }

  void addIntendation() {
    TextEditingController _updatedController = TextEditingController();

    int currentPosition = _controller.selection.start;

    String controllerText = _controller.text;
    String text = controllerText.substring(0, currentPosition) +
        "    " +
        controllerText.substring(currentPosition, controllerText.length);

    _updatedController.value = TextEditingValue(
      text: text,
      selection: TextSelection(
        baseOffset: _controller.text.length + 4,
        extentOffset: _controller.text.length + 4,
      ),
    );

    setState(() {
      _controller = _updatedController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: ColorsUtils.ide_bg_color,
        body: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8, right: 8),
                  padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: Colors.white,
                  ),
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          focusNode: _focusNode,
                          autocorrect: false,
                          maxLines: 20,
                          minLines: 10,
                          controller: _controller,
                          cursorColor: ColorsUtils.quiz_bg_light_color,
                          style: TextStyle(
                            decorationColor: ColorsUtils.quiz_bg_light_color,
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            isDense: true,
                            filled: true,
                            hintText: ConstUtils.ide_hint,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: ColorsUtils.quiz_bg_light_color,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: ColorsUtils.background_color),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: ColorsUtils.background_color),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                  color: ColorsUtils.background_color),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ConstUtils.output_note,
                          style: TextStyle(
                            fontSize: 16 * MediaQueryUtils(context).scaleFactor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQueryUtils(context).height * 0.25,
                        width: MediaQueryUtils(context).width,
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          output,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 12 * MediaQueryUtils(context).scaleFactor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 8,
              ),
              Container(
                margin: EdgeInsets.only(left: 32, right: 32),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () => addIntendation(),
                          child: Icon(
                            Icons.arrow_right_alt,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          height: 50,
                          color: Theme.of(context).accentColor,
                          child: Text(
                            ConstUtils.run_code,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () => appendAndRunPythonCode(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void appendAndRunPythonCode() async {
    FocusScope.of(context).unfocus();
    String code = _controller.text;
    String final_code = '$code\n';
    await runPythonScript(final_code);
  }
}
