import 'package:flutter/material.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/generale/pages/generic_page.dart';
import 'package:ows_test_v2/generated/assets.gen.dart';
import 'package:ows_test_v2/generated/l10n.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pagine = <Widget>[
    Text(
      S.current.ingresso_merce.toUpperCase(),
    ),
    Text(
      S.current.uscita_merce.toUpperCase(),
    ),
    Text(
      S.current.inventario.toUpperCase(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return const GenericPage(
        pageBody: Center(
      child: TextField(),
    ));
  }
}
