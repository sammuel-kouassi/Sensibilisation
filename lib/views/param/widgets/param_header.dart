import 'package:flutter/material.dart';

class ParamHeader extends StatelessWidget {
  const ParamHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          width: double.infinity,
          child: Text(
            'Paramètres',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
        Container(
          height: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
      ],
    );
  }
}