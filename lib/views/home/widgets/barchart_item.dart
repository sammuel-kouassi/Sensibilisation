import 'package:flutter/material.dart';
import '../../../models/bar_chart_model.dart';

class BarchartItem extends StatefulWidget {
  final BarchartModel barchartModels;
  final bool isActive;

  const BarchartItem({
    super.key,
    required this.barchartModels,
    this.isActive = false,
  });

  @override
  State<BarchartItem> createState() => _BarchartItemState();
}

class _BarchartItemState extends State<BarchartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnim;

  // Hauteur fixe réservée pour label + valeur + point
  // label(16) + SizedBox(8) + point(10) + SizedBox(4) + valeur(18) + padding(6) = ~62px
  static const double _fixedBottomHeight = 62.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heightAnim = Tween<double>(
      begin: 0,
      end: widget.barchartModels.height,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color1 = widget.isActive
        ? const Color(0xFF21951D)
        : const Color(0xFFFF8000);
    final color2 = widget.isActive
        ? const Color(0xFF4ade80)
        : const Color(0xFFFFB347);

    return Tooltip(
      message:
      '${widget.barchartModels.count} participants en ${widget.barchartModels.label}',
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [

          // ── Valeur (hauteur fixe) ──
          SizedBox(
            height: 18,
            child: widget.barchartModels.count > 0
                ? Text(
              widget.barchartModels.count.toString(),
              style: TextStyle(
                color: color1,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            )
                : const SizedBox.shrink(),
          ),

          const SizedBox(height: 4),

          // ── Barre animée (flexible, s'adapte à l'espace restant) ──
          Flexible(
            child: AnimatedBuilder(
              animation: _heightAnim,
              builder: (context, _) {

                final maxBarHeight = 200 - _fixedBottomHeight;
                final barH = _heightAnim.value
                    .clamp(4.0, maxBarHeight);

                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 32,
                    height: barH,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [color1, color2],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      boxShadow: widget.isActive
                          ? [
                        BoxShadow(
                          color: const Color(0xFF21951D)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          // ── Label mois (hauteur fixe) ──
          Text(
            widget.barchartModels.label,
            style: TextStyle(
              color: widget.isActive
                  ? const Color(0xFF21951D)
                  : Colors.grey[500],
              fontSize: 10,
              fontWeight:
              widget.isActive ? FontWeight.w800 : FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          // ── Point indicateur mois actuel (hauteur fixe) ──
          const SizedBox(height: 4),
          SizedBox(
            height: 6,
            child: widget.isActive
                ? Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF21951D),
                shape: BoxShape.circle,
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}