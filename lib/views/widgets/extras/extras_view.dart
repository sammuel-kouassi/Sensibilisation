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
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: _CircleIconButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Séances',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        actions: [
          if (provider.selectedSeance != null)
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () {
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F1FC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 13,
                        color: Color(0xFF3887E0),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Clore',
                        style: TextStyle(
                          color: Color(0xFF3887E0),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9500)),
            )
          : provider.seances.isEmpty
          ? const Center(
              child: Text(
                'Aucune séance.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFFFF9500),
              onRefresh: provider.loadSeances,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
                children: [
                  if (provider.selectedSeance != null)
                    _SelectedBanner(seance: provider.selectedSeance!),

                  if (provider.seancesEnCours.isNotEmpty) ...[
                    _SectionHeader(
                      label: 'En cours',
                      color: SeanceStatut.enCours.color,
                    ),
                    ...provider.seancesEnCours.map(
                      (s) => _SeanceCard(seance: s),
                    ),
                  ],

                  if (provider.seancesPlanifiees.isNotEmpty) ...[
                    _SectionHeader(
                      label: 'Planifiées',
                      color: SeanceStatut.planifiee.color,
                    ),
                    ...provider.seancesPlanifiees.map(
                      (s) => _SeanceCard(seance: s),
                    ),
                  ],

                  if (provider.seancesTerminees.isNotEmpty) ...[
                    _SectionHeader(
                      label: 'Terminées',
                      color: SeanceStatut.terminee.color,
                    ),
                    ...provider.seancesTerminees.map(
                      (s) => _SeanceCard(seance: s),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

// --- BOUTON CERCLE ICÔNE ---
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.18)),
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3887E0).withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF3887E0).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF3887E0),
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF3887E0),
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '« ${seance.nom} »',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(
                    text: ' sélectionnée — appuyez sur Clore en haut à droite.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.read<ExtrasProvider>().toggleSeance(seance),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF3887E0).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 13,
                color: Color(0xFF3887E0),
              ),
            ),
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
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 2),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.7,
            ),
          ),
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
    final statut = calculerStatut(
      datePrevue: seance.datePrevue,
      estTerminee: seance.estTerminee,
    );
    final isSelected = provider.selectedSeance?.id == seance.id;
    final isTerminee = statut == SeanceStatut.terminee;

    return GestureDetector(
      onTap: isTerminee
          ? null
          : () => context.read<ExtrasProvider>().toggleSeance(seance),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? statut.color.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? statut.color.withOpacity(0.4)
                : Colors.grey.withOpacity(0.13),
            width: isSelected ? 1.0 : 0.5,
          ),
        ),
        child: Row(
          children: [
            // Icône statut
            Container(
              width: 44,
              height: 44,
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
                  // Nom
                  Text(
                    seance.nom,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isTerminee ? Colors.grey[400] : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Badge statut + zone
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statut.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statut.label,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: statut.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (seance.zone != null) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '· ${seance.zone}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Organisateur : ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              seance.organisateur,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (seance.cible != null && seance.cible!.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.group_outlined,
                              size: 12,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Cible : ',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                seance.cible!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),

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

            const SizedBox(width: 8),

            // Trailing icon
            if (isTerminee)
              Icon(Icons.lock_rounded, size: 16, color: Colors.grey[350])
            else if (isSelected)
              Icon(Icons.check_circle_rounded, size: 20, color: statut.color)
            else
              Icon(Icons.lock_open_rounded, size: 17, color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}
