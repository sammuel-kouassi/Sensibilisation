import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/export_service.dart';
import 'export_button.dart';

class ExportSection extends StatelessWidget {
  const ExportSection({super.key});

  void _showChoiceSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Export $type", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _choiceTile(context, "Participants", Icons.group_outlined, () {
              Navigator.pop(context);
              // ✅ Appel correct des méthodes statiques
              if (type == "CSV") {
                ExportService.toCsv('participants');
              } else {
                ExportService.toPdf('participants');
              }
            }),
            _choiceTile(context, "Séances", Icons.analytics_outlined, () {
              Navigator.pop(context);
              // ✅ Appel correct des méthodes statiques
              if (type == "CSV") {
                ExportService.toCsv('seances');
              } else {
                ExportService.toPdf('seances');
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _choiceTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.watch<AuthProvider>().isAdmin;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("EXPORTS RAPPORTS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ExportButton(
                  icon: Icons.table_chart_outlined,
                  iconColor: Colors.green,
                  title: 'Excel / CSV',
                  subtitle: 'Données brutes',
                  isEnabled: isAdmin,
                  onTap: () => _showChoiceSheet(context, "CSV"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ExportButton(
                  icon: Icons.picture_as_pdf_outlined,
                  iconColor: Colors.red,
                  title: 'Rapport PDF',
                  subtitle: 'Format imprimable',
                  isEnabled: isAdmin,
                  onTap: () => _showChoiceSheet(context, "PDF"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}