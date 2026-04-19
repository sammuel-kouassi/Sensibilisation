import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart' as csv_lib;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/database/local_db.dart';
import '../../../models/seance_statut.dart';

class DataManagementView extends StatelessWidget {
  const DataManagementView({super.key});

  Future<void> _exportToCsv(BuildContext context, String tableType) async {
    List<List<dynamic>> rows = [];
    String fileName = "";

    try {
      if (tableType == 'participants') {
        final data = await localDb.getAllParticipants();
        rows.add([
          "ID",
          "Nom",
          "Prénom",
          "Téléphone",
          "Localité",
          "Quartier",
          "Date d'inscription",
        ]);

        for (var p in data) {
          rows.add([
            p.id,
            p.nom,
            p.prenom,
            p.telephone,
            p.localite,
            p.quartier ?? '',
            DateFormat('dd/MM/yyyy HH:mm').format(p.dateInscription),
          ]);
        }
        fileName =
        "rapport_participants_${DateFormat('dd_MM_yyyy_HHmm').format(DateTime.now())}.csv";
      } else if (tableType == 'seances') {
        final data = await localDb.getAllSeances();
        rows.add([
          "ID",
          "Séance",
          "Zone",
          "Objectif Participants",
          "Gadgets Distribués",
          "Statut",
          "Date Prévue",
        ]);

        for (var s in data) {
          final statut = calculerStatut(        // ← statut calculé
            datePrevue: s.datePrevue,
            estTerminee: s.estTerminee,
          );
          rows.add([
            s.serverId ?? 'Local',
            s.nom,
            s.zone,
            s.objectifParticipants,
            s.gadgetsDistribues,
            statut.label,                       // ← "Planifiée" / "En cours" / "Terminée"
            DateFormat('dd/MM/yyyy').format(s.datePrevue),
          ]);
        }
        fileName =
        "rapport_seances_${DateFormat('dd_MM_yyyy_HHmm').format(DateTime.now())}.csv";
      }

      String csvData = const csv_lib.ListToCsvConverter().convert(rows);
      final dir = await getTemporaryDirectory();
      final file = File("${dir.path}/$fileName");
      await file.writeAsString(csvData);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
        'Rapport d\'activité DLF - Généré le ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
      );
    } catch (e) {
      debugPrint('❌ Erreur Export : $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text("Vider le cache ?"),
          ],
        ),
        content: const Text(
          "Toutes les données (participants, séances, RDV) non synchronisées seront définitivement perdues de cet appareil.",
          style: TextStyle(color: Color(0xFF64748B), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Annuler",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              try {
                await localDb.clearSeances();
                await localDb.clearParticipants();
                await localDb.clearRdvs();
                await localDb.clearPriseContacts();

                localDb.notifyDataChanged();

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Cache local entièrement vidé'),
                      backgroundColor: Color(0xFF21951D),
                    ),
                  );
                }
              } catch (e) {
                debugPrint('❌ Erreur lors du nettoyage : $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erreur lors de la suppression'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              "Confirmer",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Données & rapports',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          _buildSectionHeader("MAINTENANCE"),
          const SizedBox(height: 16),
          _buildCard(
            context,
            "Nettoyer le cache",
            "Effacer les données locales stockées",
            Icons.delete_sweep_outlined,
            Colors.red,
                () => _confirmClear(context),
          ),

          const SizedBox(height: 32),

          _buildSectionHeader("GÉNÉRER DES RAPPORTS EXCEL"),
          const SizedBox(height: 16),
          _buildCard(
            context,
            "Liste des Participants",
            "Exporter tous les inscrits (CSV)",
            Icons.people_alt_outlined,
            const Color(0xFF21951D),
                () => _exportToCsv(context, 'participants'),
          ),
          const SizedBox(height: 16),
          _buildCard(
            context,
            "Historique des Séances",
            "Rapport des sensibilisations réalisées",
            Icons.assignment_outlined,
            const Color(0xFFFF8000),
                () => _exportToCsv(context, 'seances'),
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              "Format de fichier compatible Excel (.csv)",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF94A3B8),
        fontSize: 12,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      String title,
      String sub,
      IconData icon,
      Color col,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: col.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: col, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sub,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[300], size: 14),
          ],
        ),
      ),
    );
  }
}