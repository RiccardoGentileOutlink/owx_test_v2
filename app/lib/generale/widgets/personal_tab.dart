import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PersonalTab extends StatelessWidget {
  final String testo;

  const PersonalTab(this.testo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      testo.toUpperCase(),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 2),
    );
  }
}
