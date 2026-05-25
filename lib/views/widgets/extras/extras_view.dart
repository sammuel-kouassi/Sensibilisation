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

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);
  static const _blue = Color(0xFF3887E0);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExtrasProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: CustomScrollView(
        slivers: [
          // ── AppBar gradient orange ──
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: _orange,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (provider.selectedSeance != null)
                GestureDetector(
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
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            size: 15, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Photos',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_orange, Color(0xFFe06b00)],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20, top: -20,
                      child: Container(
                        width: 140, height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30, bottom: -10,
                      child: Container(
                        width: 100, height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Séances',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              provider.selectedSeance != null
                                  ? '« ${provider.selectedSeance!.nom} » sélectionnée'
                                  : 'Sélectionnez une séance pour ajouter des photos',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Contenu ──
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: _orange),
              ),
            )
          else if (provider.seances.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: _orange.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.event_outlined,
                          size: 40,
                          color: _orange.withValues(alpha: 0.4)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Aucune séance disponible',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _dark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Les séances apparaîtront ici\naprès synchronisation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Banner séance sélectionnée ──
                  if (provider.selectedSeance != null) ...[
                    _SelectedBanner(seance: provider.selectedSeance!),
                    const SizedBox(height: 8),
                  ],

                  // ── En cours ──
                  if (provider.seancesEnCours.isNotEmpty) ...[
                    _SectionHeader(
                      label: 'En cours',
                      color: SeanceStatut.enCours.color,
                      count: provider.seancesEnCours.length,
                    ),
                    ...provider.seancesEnCours.map(
                            (s) => _SeanceCard(seance: s)),
                  ],

                  // ── Planifiées ──
                  if (provider.seancesPlanifiees.isNotEmpty) ...[
                    _SectionHeader(
                      label: 'Planifiées',
                      color: SeanceStatut.planifiee.color,
                      count: provider.seancesPlanifiees.length,
                    ),
                    ...provider.seancesPlanifiees.map(
                            (s) => _SeanceCard(seance: s)),
                  ],

                  // ── Terminées ──
                  if (provider.seancesTerminees.isNotEmpty) ...[
                    _SectionHeader(
                      label: 'Terminées',
                      color: SeanceStatut.terminee.color,
                      count: provider.seancesTerminees.length,
                    ),
                    ...provider.seancesTerminees.map(
                            (s) => _SeanceCard(seance: s)),
                  ],
                ]),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Banner séance sélectionnée ──
class _SelectedBanner extends StatelessWidget {
  final SeancesTableData seance;
  const _SelectedBanner({required this.seance});

  static const _blue = Color(0xFF3887E0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _blue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _blue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: _blue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: _blue.withValues(alpha: 0.8),
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '« ${seance.nom} »',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(
                    text: ' sélectionnée — appuyez sur Photos.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () =>
                context.read<ExtrasProvider>().toggleSeance(seance),
            child: Container(
              width: 26, height: 26,
              decoration: BoxDecoration(
                color: _blue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close_rounded,
                  size: 14, color: _blue),
            ),
          ),
        ],
      ),
    );
  }
}

// ── En-tête de section ──
class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  final int count;

  const _SectionHeader({
    required this.label,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 2),
      child: Row(
        children: [
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
                color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: color.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Carte séance ──
class _SeanceCard extends StatelessWidget {
  final SeancesTableData seance;
  const _SeanceCard({required this.seance});

  static const _dark = Color(0xFF1E293B);

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
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? statut.color.withValues(alpha: 0.5)
                : const Color(0xFFEEF0F3),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? statut.color.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icône statut
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: statut.color.withValues(
                      alpha: isTerminee ? 0.06 : 0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  isTerminee
                      ? Icons.lock_rounded
                      : Icons.event_outlined,
                  color: statut.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seance.nom,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isTerminee
                            ? Colors.grey[400]
                            : _dark,
                        letterSpacing: -0.1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statut.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            statut.label,
                            style: TextStyle(
                              fontSize: 10,
                              color: statut.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (seance.zone != null) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.location_on_outlined,
                              size: 11, color: Colors.grey[400]),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              seance.zone!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person_outline_rounded,
                            size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            seance.organisateur,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (seance.cible != null &&
                            seance.cible!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.group_outlined,
                              size: 12, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              seance.cible!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (isTerminee &&
                        seance.nbParticipantsEstime != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${seance.nbParticipantsEstime} participants estimés',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Trailing
              if (isTerminee)
                Icon(Icons.lock_rounded,
                    size: 16, color: Colors.grey[300])
              else if (isSelected)
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: statut.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_rounded,
                      size: 16, color: statut.color),
                )
              else
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt_outlined,
                      size: 14, color: Colors.grey[400]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}