import 'package:flutter/material.dart';
import 'package:ows_test_v2/generated/l10n.dart';

class PulsanteModifica extends StatelessWidget {
  final Function()? azione;

  const PulsanteModifica({super.key, this.azione});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit, color: Colors.blueGrey),
      tooltip: S.current.modifica,
      onPressed: azione,
    );
  }
}

class PulsanteElimina extends StatelessWidget {
  final Function()? azione;

  const PulsanteElimina({super.key, this.azione});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.blueGrey),
      tooltip: S.current.elimina,
      onPressed: azione,
    );
  }
}
