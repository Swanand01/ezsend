import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sharefile/DownloadPage.dart';
import 'package:sharefile/HomePage.dart';
import 'package:oktoast/oktoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    locationBuilder: SimpleLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context, state) => HomePage(),
        '/download/:fileId': (context, state) {
          // Take the parameter of interest from BeamState
          final fileId = state.pathParameters['fileId']!;
          // Return a Widget or wrap it in a BeamPage for more flexibility
          return BeamPage(
            key: ValueKey('file-$fileId'),
            title: 'A Book #$fileId',
            popToNamed: '/',
            type: BeamPageType.scaleTransition,
            child: DownloadPage(enc: fileId),
          );
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp.router(
        routeInformationParser: BeamerParser(),
        routerDelegate: routerDelegate,
      ),
    );
  }
}
