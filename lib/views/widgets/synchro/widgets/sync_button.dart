import 'package:flutter/material.dart';

class SyncButton extends StatefulWidget {
  final bool isSyncing;
  final VoidCallback onSync;

  const SyncButton({
    super.key,
    required this.isSyncing,
    required this.onSync,
  });

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateCtrl;

  @override
  void initState() {
    super.initState();
    _rotateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void didUpdateWidget(SyncButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSyncing) {
      _rotateCtrl.repeat();
    } else {
      _rotateCtrl.stop();
      _rotateCtrl.reset();
    }
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isSyncing ? null : widget.onSync,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: widget.isSyncing
              ? Colors.grey[400]
              : const Color(0xFF21951D),
          borderRadius: BorderRadius.circular(18),
          boxShadow: widget.isSyncing
              ? []
              : [
            BoxShadow(
              color: const Color(0xFF21951D).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _rotateCtrl,
              child: Icon(
                widget.isSyncing
                    ? Icons.sync_rounded
                    : Icons.cloud_sync_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              widget.isSyncing
                  ? 'Synchronisation en cours...'
                  : 'Synchroniser maintenant',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}