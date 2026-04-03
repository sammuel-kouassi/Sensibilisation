import 'package:flutter/material.dart';

class GadgetHeader extends StatelessWidget {
  final VoidCallback onScannerPressed;

  const GadgetHeader({super.key, required this.onScannerPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,


          padding: const EdgeInsets.fromLTRB(16, 20, 24, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 22),
                    onPressed: () => Navigator.pop(context),
                    splashRadius: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Gadgets',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),

        Container(
          height: 1,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}