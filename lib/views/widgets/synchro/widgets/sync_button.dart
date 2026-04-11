import 'package:flutter/material.dart';

class SyncButton extends StatelessWidget {
  final bool isSyncing;
  final VoidCallback onSync;

  const SyncButton({super.key, required this.isSyncing, required this.onSync});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSyncing ? null : onSync,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSyncing ? Colors.grey[400] : const Color(0xFFFF9500),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSyncing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              const Icon(Icons.sync, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              isSyncing ? 'Synchronisation...' : 'Synchroniser maintenant',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
