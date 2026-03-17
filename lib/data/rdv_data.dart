import '../models/rdv_model.dart';

class RdvData {
  static List<RdvModel> getRdvs() {
    return [
      RdvModel(
        titre: 'Séance Abobo Centre',
        statut: 'Planifié',
        date: '2026-03-05 à 09:00',
        lieu: 'Mairie Abobo',
        campagne: 'Sensibilisation Abobo',
      ),
      RdvModel(
        titre: 'Réunion équipe Yopougon',
        statut: 'Planifié',
        date: '2026-03-06 à 14:00',
        lieu: 'Agence CIE Yopougon',
        campagne: 'Campagne Yopougon Nord',
      ),
      RdvModel(
        titre: 'Visite terrain Marcory',
        statut: 'Terminé',
        date: '2026-03-04 à 10:30',
        lieu: 'Place Marcory',
        campagne: 'Campagne Marcory',
      ),
      RdvModel(
        titre: 'Formation agents Plateau',
        statut: 'Planifié',
        date: '2026-03-07 à 08:00',
        lieu: 'Direction Régionale',
        campagne: 'Mission Plateau',
      ),
    ];
  }
}