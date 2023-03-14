import 'package:flutter/material.dart';

class SeparatoreAppBar extends StatelessWidget {
  const SeparatoreAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: VerticalDivider(
        width: 0.5,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}
