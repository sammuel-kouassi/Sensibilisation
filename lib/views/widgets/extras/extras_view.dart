import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/database/local_db.dart';
import '../../../models/seance_statut.dart';
import '../../../providers/extras_provider.dart';
import 'widgets/image_close_flow.dart';

class ExtrasView extends StatelessWidget {
  const ExtrasView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExtrasProvider(),
      child: const _ExtrasContent(),
    );
  }
}

class _ExtrasContent extends StatelessWidget {
  const _ExtrasContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExtrasProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Séances', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          if (provider.selectedSeance != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: context.read<ExtrasProvider>(),
                        child: const ImageCloseFlow(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.camera_alt_outlined, size: 18, color: Color(0xFF2196F3)),
                label: const Text('Clore', style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9500)))
          : provider.seances.isEmpty
          ? const Center(child: Text('Aucune séance.', style: TextStyle(color: Colors.grey)))
          : RefreshIndicator(
        color: const Color(0xFFFF9500),
        onRefresh: provider.loadSeances,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            // Info sélection
            if (provider.selectedSeance != null)
              _SelectedBanner(seance: provider.selectedSeance!),

            // Section En cours
            if (provider.seancesEnCours.isNotEmpty) ...[
              _SectionHeader(label: 'En cours', color: SeanceStatut.enCours.color),
              ...provider.seancesEnCours.map((s) => _SeanceCard(seance: s)),
            ],

            // Section Planifiées
            if (provider.seancesPlanifiees.isNotEmpty) ...[
              _SectionHeader(label: 'Planifiées', color: SeanceStatut.planifiee.color),
              ...provider.seancesPlanifiees.map((s) => _SeanceCard(seance: s)),
            ],

            // Section Terminées
            if (provider.seancesTerminees.isNotEmpty) ...[
              _SectionHeader(label: 'Terminées', color: SeanceStatut.terminee.color),
              ...provider.seancesTerminees.map((s) => _SeanceCard(seance: s)),
            ],
          ],
        ),
      ),
    );
  }
}

// --- BANNER SÉANCE SÉLECTIONNÉE ---
class _SelectedBanner extends StatelessWidget {
  final SeancesTableData seance;
  const _SelectedBanner({required this.seance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF2196F3), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '« ${seance.nom} » sélectionnée — appuyez sur Clore en haut à droite.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF2196F3), fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () => context.read<ExtrasProvider>().toggleSeance(seance),
            child: const Icon(Icons.close, size: 16, color: Color(0xFF2196F3)),
          ),
        ],
      ),
    );
  }
}

// --- EN-TÊTE DE SECTION ---
class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10, left: 4),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// --- CARTE SÉANCE ---
class _SeanceCard extends StatelessWidget {
  final SeancesTableData seance;
  const _SeanceCard({required this.seance});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExtrasProvider>();
    final statut = calculerStatut(datePrevue: seance.datePrevue, estTerminee: seance.estTerminee);
    final isSelected = provider.selectedSeance?.id == seance.id;
    final isTerminee = statut == SeanceStatut.terminee;

    return GestureDetector(
      onTap: isTerminee ? null : () => context.read<ExtrasProvider>().toggleSeance(seance),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? statut.color.withOpacity(0.07)
              : isTerminee
              ? Colors.grey[100]
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? statut.color.withOpacity(0.35)
                : Colors.grey.withOpacity(0.12),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Icône statut
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: statut.color.withOpacity(isTerminee ? 0.06 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isTerminee ? Icons.lock_rounded : Icons.event_outlined,
                color: statut.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Infos séance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seance.nom,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isTerminee ? Colors.grey[500] : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Badge statut
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: statut.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statut.label,
                          style: TextStyle(fontSize: 10, color: statut.color, fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (seance.zone != null) ...[
                        const SizedBox(width: 6),
                        Text('· ${seance.zone}', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                      ],
                    ],
                  ),
                  // Nb participants estimé si clôturée
                  if (isTerminee && seance.nbParticipantsEstime != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${seance.nbParticipantsEstime} participants estimés',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ],
              ),
            ),

            // Cadenas ou check
            if (isTerminee)
              Icon(Icons.lock_rounded, size: 18, color: Colors.grey[400])
            else if (isSelected)
              Icon(Icons.check_circle_rounded, size: 20, color: statut.color)
            else
              Icon(Icons.lock_open_rounded, size: 18, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}