//evita che si chiuda il diaolog cliccando sul tasto indietro
import 'package:flutter/material.dart';

class AlertDialogModale extends StatelessWidget {
  final AlertDialog dialog;
  const AlertDialogModale(this.dialog, {super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: dialog,
    );
  }
}
