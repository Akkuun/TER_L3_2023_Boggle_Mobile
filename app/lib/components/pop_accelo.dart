import 'package:bouggr/components/popup.dart';
import 'package:bouggr/providers/game.dart';
import 'package:flutter/material.dart';

class _accelo extends StatelessWidget {
  const _accelo({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class PopAccelo extends StatelessWidget {
  const PopAccelo({super.key});

  @override
  Widget build(BuildContext context) {
    return PopUp<GameServices>(child: const _accelo());
  }
}
