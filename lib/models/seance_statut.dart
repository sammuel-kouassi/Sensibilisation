import 'dart:ui';

enum SeanceStatut { planifiee, enCours, terminee }

extension SeanceStatutExtension on SeanceStatut {
  String get label {
    switch (this) {
      case SeanceStatut.planifiee:
        return 'Planifiée';
      case SeanceStatut.enCours:
        return 'En cours';
      case SeanceStatut.terminee:
        return 'Terminée';
    }
  }

  Color get color {
    switch (this) {
      case SeanceStatut.planifiee:
        return const Color(0xFF2196F3);
      case SeanceStatut.enCours:
        return const Color(0xFF21951D);
      case SeanceStatut.terminee:
        return const Color(0xFF9E9E9E);
    }
  }

  Color get bgColor {
    switch (this) {
      case SeanceStatut.planifiee:
        return const Color(0xFFE3F2FD);
      case SeanceStatut.enCours:
        return const Color(0xFFE8F5E9);
      case SeanceStatut.terminee:
        return const Color(0xFFF5F5F5);
    }
  }
}

/// Calcule le statut à partir des données brutes
SeanceStatut calculerStatut({
  required DateTime datePrevue,
  required bool estTerminee,
}) {
  if (estTerminee) return SeanceStatut.terminee;

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final jourSeance = DateTime(
    datePrevue.year,
    datePrevue.month,
    datePrevue.day,
  );

  if (jourSeance.isAtSameMomentAs(today)) return SeanceStatut.enCours;
  if (jourSeance.isBefore(today)) return SeanceStatut.terminee;
  return SeanceStatut.planifiee;
}
