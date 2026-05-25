import 'package:cie_services/views/widgets/rdv/widgets/rdv_history_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/rdv_model.dart';
import '../../../providers/rdv_provider.dart';
import '../forms/rendez-vous_form.dart';

class RdvView extends StatelessWidget {
  const RdvView({super.key});

  static const _vert = Color(0xFF21951D);

  Future<void> _onPlanifierPressed(
      BuildContext context,
      RdvProvider provider,
      ) async {
    final nouveauRdv = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RdvForm()),
    );
    if (nouveauRdv != null && nouveauRdv is RdvModel) {
      provider.addRdv(nouveauRdv);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Rendez-vous planifié avec succès !'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Consumer<RdvProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // ── AppBar gradient vert ──
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: _vert,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Bouton Planifier dans l'appbar
                  GestureDetector(
                    onTap: () => _onPlanifierPressed(context, provider),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Planifier',
                            style: TextStyle(
                              color: Colors.white,
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
                        colors: [_vert, Color(0xFF167013)],
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
                                  'Rendez-vous',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.rdvs.isEmpty
                                      ? 'Aucun rendez-vous planifié'
                                      : '${provider.rdvs.length} rendez-vous',
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

              // ── Contenu ──
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: _vert),
                  ),
                )
              else if (provider.rdvs.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: _vert.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.calendar_month_outlined,
                              size: 40,
                              color: _vert.withValues(alpha: 0.4)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Aucun rendez-vous planifié',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Appuyez sur "Planifier" pour créer\nvotre premier rendez-vous',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        GestureDetector(
                          onTap: () =>
                              _onPlanifierPressed(context, provider),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: _vert,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _vert.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Planifier un RDV',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.only(top: 8, bottom: 40),
                  sliver: SliverToBoxAdapter(
                    child: RdvHistoryView(
                      rdvs: provider.rdvs,
                      onEdit: (rdv) async {
                        final updatedRdv = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RdvForm(rdv: rdv),
                          ),
                        );
                        if (updatedRdv != null && updatedRdv is RdvModel) {
                          provider.updateRdv(updatedRdv);
                        }
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}