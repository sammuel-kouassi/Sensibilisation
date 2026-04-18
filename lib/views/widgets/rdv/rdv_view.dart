import 'package:cie_services/views/widgets/rdv/widgets/rdv_history_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/rdv_model.dart';
import '../../../providers/rdv_provider.dart';
import '../forms/rendez-vous_form.dart';
import 'widgets/rdv_header.dart';

class RdvView extends StatelessWidget {
  const RdvView({super.key});

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
          const SnackBar(
            content: Text('Rendez-vous planifié avec succès !'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Consumer<RdvProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  RdvHeader(
                    onPlanifierPressed: () =>
                        _onPlanifierPressed(context, provider),
                  ),

                  const SizedBox(height: 24),

                  if (provider.isLoading)
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF97316),
                        ),
                      ),
                    )
                  else if (provider.rdvs.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Aucun rendez-vous prévu.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  else
                    Expanded(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
