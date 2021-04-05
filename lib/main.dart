import 'dart:async';

import 'package:dcodeai_playground/pages/cv_ide_page.dart';
import 'package:dcodeai_playground/pages/cv_rgb_ide_page.dart';
import 'package:dcodeai_playground/pages/matplotlib_ide_page.dart';
import 'package:dcodeai_playground/pages/nltk_ide_page.dart';
import 'package:dcodeai_playground/pages/text_ide_page.dart';
import 'package:dcodeai_playground/utils/mediaquery.dart';
import 'package:dcodeai_playground/utils/page_decider.dart';
import 'package:dcodeai_playground/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playground',
      theme: ThemeUtils.getDefaultTheme(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget currentIDEPage = TextIDEPage();

  StreamSubscription _linkSubscription;
  Stream<Uri> _uriLinkStream;

  //  * sets IDE page according to external app request...
  void parseURI() {
    _uriLinkStream = getUriLinksStream();
    _linkSubscription = _uriLinkStream.listen((Uri uri) {
      currentIDEPage = PageDecider.returnPage(uri.pathSegments.last);
      setState(() {});
    }, onError: (e) {
      //  * open playstore app link here...
    });
  }

  @override
  void initState() {
    parseURI();
    super.initState();
  }

  @override
  void dispose() {
    _linkSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playground')),
      body: currentIDEPage,
      drawer: Drawer(
        elevation: 8,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'images/app_icon.png',
                    fit: BoxFit.fill,
                    height: 50,
                    width: 50,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    width: 200,
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'DcodeAI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24 * MediaQueryUtils(context).scaleFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Text based IDE'),
              onTap: () {
                currentIDEPage = TextIDEPage();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text('Matplotlib based IDE'),
              onTap: () {
                currentIDEPage = MatplotlibIDEPage();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text('NLTK IDE'),
              onTap: () {
                currentIDEPage = NLTKIDEPage();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text('Computer Vision IDE'),
              onTap: () {
                currentIDEPage = CVIDEPage();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text('Computer Vision RGB IDE'),
              onTap: () {
                currentIDEPage = CVRGBIDEPage();
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
