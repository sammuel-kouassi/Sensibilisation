import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/export_service.dart';
import 'export_button.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  static const _dark = Color(0xFF1E293B);

  void _showChoiceSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: type == 'CSV'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    type == 'CSV'
                        ? Icons.table_chart_outlined
                        : Icons.picture_as_pdf_outlined,
                    color:
                    type == 'CSV' ? Colors.green : Colors.red,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Export $type',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _dark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _choiceTile(
              context,
              'Participants',
              Icons.group_outlined,
              const Color(0xFFFF8000),
                  () {
                Navigator.pop(context);
                if (type == 'CSV') {
                  ExportService.toCsv('participants');
                } else {
                  ExportService.toPdf('participants');
                }
              },
            ),
            const SizedBox(height: 8),
            _choiceTile(
              context,
              'Séances',
              Icons.event_note_outlined,
              const Color(0xFF21951D),
                  () {
                Navigator.pop(context);
                if (type == 'CSV') {
                  ExportService.toCsv('seances');
                } else {
                  ExportService.toPdf('seances');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _choiceTile(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF8000),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Exports & rapports',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF8000),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ExportButton(
                  icon: Icons.table_chart_outlined,
                  iconColor: Colors.green[600]!,
                  title: 'Excel / CSV',
                  subtitle: 'Données brutes',
                  isEnabled: isAdmin,
                  onTap: () => _showChoiceSheet(context, 'CSV'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ExportButton(
                  icon: Icons.picture_as_pdf_outlined,
                  iconColor: Colors.red[600]!,
                  title: 'Rapport PDF',
                  subtitle: 'Format imprimable',
                  isEnabled: isAdmin,
                  onTap: () => _showChoiceSheet(context, 'PDF'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}