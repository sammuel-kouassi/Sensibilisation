import 'package:cie_services/views/participant/widgets/participant_seance_filter.dart';
import 'package:cie_services/views/participant/widgets/participants_history_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/participant_model.dart';
import '../../models/seance_statut.dart';
import '../../core/database/local_db.dart';
import '../../providers/participant_provider.dart';
import '../widgets/animated_section.dart';
import '../widgets/forms/participant_form.dart';
import 'widgets/participant_search_bar.dart';

class ParticipantView extends StatefulWidget {
  const ParticipantView({super.key});

  @override
  State<ParticipantView> createState() => _ParticipantViewState();
}

class _ParticipantViewState extends State<ParticipantView> {
  final TextEditingController _searchController = TextEditingController();

  static const _orange = Color(0xFFFF8000);
  static const _dark = Color(0xFF1E293B);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _canAddParticipant(ParticipantProvider provider) {
    final selectedId = provider.selectedSeanceId;
    if (selectedId == null) return true;

    return provider.seances.any((s) {
      // ✅ Compare avec serverId OU id local
      final matchId = s.serverId ?? s.id;
      if (matchId != selectedId) return false;
      final statut = calculerStatut(
        datePrevue: s.datePrevue,
        estTerminee: s.estTerminee,
      );
      return statut == SeanceStatut.enCours;
    });
  }

  Future<void> _onAddParticipantPressed(
      BuildContext context,
      ParticipantProvider provider,
      ) async {
    // ✅ Double vérification côté logique
    if (!_canAddParticipant(provider)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.lock_rounded, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('Ajout impossible : séance non en cours'),
            ],
          ),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final nouveauParticipant = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParticipantForm()),
    );

    if (nouveauParticipant != null &&
        nouveauParticipant is ParticipantModel) {
      provider.addParticipant(nouveauParticipant);
      _searchController.clear();
      provider.filterParticipants('');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Participant ajouté avec succès !'),
              ],
            ),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _onEditParticipant(
      BuildContext context,
      ParticipantProvider provider,
      ParticipantModel participant,
      ) async {
    final updatedParticipant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantForm(participant: participant),
      ),
    );

    if (updatedParticipant != null &&
        updatedParticipant is ParticipantModel) {
      provider.updateParticipant(updatedParticipant);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Participant modifié avec succès !'),
              ],
            ),
            backgroundColor: Colors.blue[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ParticipantProvider(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Consumer<ParticipantProvider>(
          builder: (context, provider, child) {
            final canAdd = _canAddParticipant(provider);

            return CustomScrollView(
              slivers: [
                // ── AppBar gradient orange ──
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  backgroundColor: _orange,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () =>
                          _onAddParticipantPressed(context, provider),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: canAdd
                              ? Colors.white.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: canAdd
                                ? Colors.white.withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              canAdd
                                  ? Icons.person_add_rounded
                                  : Icons.lock_rounded,
                              color: canAdd
                                  ? Colors.white
                                  : Colors.white
                                  .withValues(alpha: 0.4),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Ajouter',
                              style: TextStyle(
                                color: canAdd
                                    ? Colors.white
                                    : Colors.white
                                    .withValues(alpha: 0.4),
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
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
                                color: Colors.white
                                    .withValues(alpha: 0.07),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -30, bottom: -10,
                            child: Container(
                              width: 100, height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                                    .withValues(alpha: 0.05),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20, 0, 20, 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Participants',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    provider.filteredParticipants.isEmpty
                                        ? 'Aucun participant enregistré'
                                        : '${provider.filteredParticipants.length} participant(s)',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
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

                // ── Recherche + filtre séance ──
                SliverToBoxAdapter(
                  child: AnimatedSection(
                    delayMs: 100,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: ParticipantSearchBar(
                            controller: _searchController,
                            onChanged: provider.filterParticipants,
                            seances: provider.seances,
                            selectedSeanceId: provider.selectedSeanceId,
                            onSeanceSelected: (id) {
                              _searchController.clear();
                              provider.filterBySeance(id);
                            },
                          ),
                        ),
                        if (provider.seances.isNotEmpty)
                          ParticipantSeanceFilter(
                            seances: provider.seances,
                            selectedSeanceId: provider.selectedSeanceId,
                            onSelected: (id) {
                              _searchController.clear();
                              provider.filterBySeance(id);
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                // ── Compteur ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _orange.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${provider.filteredParticipants.length} résultat(s)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _orange.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                        if (provider.selectedSeanceId != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '· filtrés par séance',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          // ✅ Indicateur visuel si ajout non autorisé
                          if (!canAdd) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.orange
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_outline_rounded,
                                      size: 11,
                                      color: Colors.orange[700]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Ajout désactivé',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),

                // ── États ──
                if (provider.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _orange),
                    ),
                  )
                else if (provider.filteredParticipants.isEmpty)
                  SliverFillRemaining(
                    // ✅ hasScrollBody pour éviter le overflow quand clavier ouvert
                    hasScrollBody: false,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: _orange.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.people_outline_rounded,
                                size: 40,
                                color: _orange.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucun participant trouvé',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _dark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              canAdd
                                  ? 'Essayez un autre terme\nou ajoutez un participant'
                                  : 'Aucun participant dans cette séance',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: canAdd
                                  ? () => _onAddParticipantPressed(context, provider)
                                  : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                decoration: BoxDecoration(
                                  color: canAdd ? _orange : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: canAdd
                                      ? [
                                    BoxShadow(
                                      color: _orange.withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      canAdd
                                          ? Icons.person_add_rounded
                                          : Icons.lock_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      canAdd
                                          ? 'Ajouter un participant'
                                          : 'Séance non disponible',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 4, bottom: 40),
                    sliver: SliverToBoxAdapter(
                      child: RefreshIndicator(
                        color: _orange,
                        backgroundColor: Colors.white,
                        onRefresh: () => provider.syncFromServer(),
                        child: AnimatedSection(
                          delayMs: 200,
                          child: ParticipantsHistoryView(
                            participants:
                            provider.filteredParticipants,
                            onEdit: (p) => _onEditParticipant(
                                context, provider, p),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}