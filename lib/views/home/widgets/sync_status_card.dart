import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_provider.dart';

class SyncStatusCard extends StatelessWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final isOnline = provider.isOnline;
    final pendingCount = provider.pendingSyncOperations;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOnline
              ? [const Color(0xFF1E293B), const Color(0xFF0f172a)]
              : [const Color(0xFF2D1B00), const Color(0xFF1a1000)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          // Cercle décoratif
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? const Color(0xFFFF8000).withValues(alpha: 0.2)
                            : Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          isOnline
                              ? Icons.cloud_done_outlined
                              : Icons.cloud_off_outlined,
                          size: 26,
                          color: isOnline
                              ? const Color(0xFFFF8000)
                              : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Synchronisation',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pendingCount > 0
                                ? '$pendingCount opération(s) en attente'
                                : 'Toutes les données sont à jour',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isOnline
                        ? const Color(0xFF1a8a17).withValues(alpha: 0.5)
                        : Colors.orange.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: isOnline
                      ? const Color(0xFF1a8a17).withValues(alpha: 0.15)
                      : Colors.orange.withValues(alpha: 0.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PulseDot(isOnline: isOnline),
                    const SizedBox(width: 6),
                    Text(
                      isOnline ? 'Connecté' : 'Hors-ligne',
                      style: TextStyle(
                        color: isOnline
                            ? const Color(0xFF4ade80)
                            : Colors.orange[300],
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  final bool isOnline;
  const _PulseDot({required this.isOnline});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.isOnline ? _anim : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isOnline ? const Color(0xFF4ade80) : Colors.orange[300],
        ),
      ),
    );
  }
}