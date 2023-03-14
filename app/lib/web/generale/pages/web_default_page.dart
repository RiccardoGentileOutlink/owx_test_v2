import 'package:flutter/cupertino.dart';
import 'package:ows_test_v2/generale/pages/generic_page.dart';

class WebDefaultPage extends StatelessWidget {
  const WebDefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericPage(
      pageBody: Center(child: Text('Home page web')),
    );
  }
}
