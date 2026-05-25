import 'package:flutter/material.dart';

class ConnectionCard extends StatelessWidget {
  final bool isOnline;

  const ConnectionCard({super.key, this.isOnline = true});

  @override
  Widget build(BuildContext context) {
    final Color mainColor =
    isOnline ? const Color(0xFF21951D) : Colors.grey[600]!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOnline
              ? [const Color(0xFF1E293B), const Color(0xFF0f172a)]
              : [Colors.grey[800]!, Colors.grey[900]!],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Icône
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: mainColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isOnline ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              color: isOnline ? const Color(0xFF4ade80) : Colors.grey[400],
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnline ? 'Connecté' : 'Hors ligne',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isOnline
                      ? 'Réseau disponible'
                      : 'En attente de réseau',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Badge animé
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(
                color: isOnline
                    ? const Color(0xFF21951D).withValues(alpha: 0.5)
                    : Colors.grey.withValues(alpha: 0.3),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
              color: isOnline
                  ? const Color(0xFF21951D).withValues(alpha: 0.15)
                  : Colors.grey.withValues(alpha: 0.1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PulseDot(isOnline: isOnline),
                const SizedBox(width: 6),
                Text(
                  isOnline ? 'En ligne' : 'Déconnecté',
                  style: TextStyle(
                    color: isOnline
                        ? const Color(0xFF4ade80)
                        : Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.isOnline ? _anim : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 7, height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isOnline
              ? const Color(0xFF4ade80)
              : Colors.grey[400],
        ),
      ),
    );
  }
}