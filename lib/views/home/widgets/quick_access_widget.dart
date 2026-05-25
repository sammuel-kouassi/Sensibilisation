import 'package:flutter/material.dart';
import '../../../models/quick_access_model.dart';

class QuickAccessWidget extends StatefulWidget {
  final QuickAccessModel quickAccessModel;

  const QuickAccessWidget({super.key, required this.quickAccessModel});

  @override
  State<QuickAccessWidget> createState() => _QuickAccessWidgetState();
}

class _QuickAccessWidgetState extends State<QuickAccessWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.92,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) {
        _controller.forward();
        widget.quickAccessModel.onTap?.call();
      },
      onTapCancel: () => _controller.forward(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: widget.quickAccessModel.backgroundColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: widget.quickAccessModel.iconColor
                            .withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      widget.quickAccessModel.icon,
                      size: 28,
                      color: widget.quickAccessModel.iconColor,
                    ),
                  ),
                ),
                if (widget.quickAccessModel.badgeCount > 0)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        widget.quickAccessModel.badgeCount > 9
                            ? '9+'
                            : widget.quickAccessModel.badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.quickAccessModel.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF334155),
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}