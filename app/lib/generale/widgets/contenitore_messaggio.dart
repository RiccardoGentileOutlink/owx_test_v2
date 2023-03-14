import 'package:flutter/material.dart';
import 'package:ows_test_v2/estensioni.dart';
import 'package:ows_test_v2/utility.dart';

class ContenitoreMessaggio extends StatelessWidget {
  final String testo;
  final String tipo;

  static const String tipoErrore = "E";
  static const String tipoAlert = "A";
  static const String tipoMessaggio = "M";

  const ContenitoreMessaggio({super.key, required this.testo, required this.tipo});

  @override
  Widget build(BuildContext context) {
    Color? colore;
    Color? coloreIcona;
    Color? coloreBordo;
    IconData? icona;

    if (tipo == tipoErrore) {
      colore = Colors.red[100];
      coloreIcona = Colors.red[400];
      coloreBordo = Colors.red;
      icona = Icons.cancel;
    }
    if (tipo == tipoAlert) {
      colore = Colors.yellow[200];
      coloreIcona = Colors.yellow[700];
      coloreBordo = Colors.yellow;
      icona = Icons.info;
    }
    if (tipo == tipoMessaggio) {
      colore = Colors.green[100];
      coloreIcona = Colors.green[600];
      coloreBordo = Colors.green;
      icona = Icons.check_circle;
    }

    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(ValoriDefault.defaultPadding),
      margin: const EdgeInsets.only(top: ValoriDefault.defaultPadding),
      decoration: BoxDecoration(
        color: colore,
        border: Border.all(
          color: coloreBordo!,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icona,
            color: coloreIcona,
          ),
          const SizedBox(
            width: ValoriDefault.defaultPadding,
          ),
          Expanded(
            child: Text(
              testo.capitalize(),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
