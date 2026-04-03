import 'dart:ui';
import 'package:cie_services/models/repartzone_models.dart';

class RepartzoneData {
  static List<RepartzoneModels> getZoneStats() {
    return [
      RepartzoneModels(zoneName: 'Yopougon', percentage: 21, valeurExacte: 180, color: const Color(0xFF21951D)),
      RepartzoneModels(zoneName: 'Abobo', percentage: 27, valeurExacte: 231, color: const Color(0xFFFF8000)),
      RepartzoneModels(zoneName: 'Plateau', percentage: 5, valeurExacte: 42, color: const Color(0xFF3B82F6)),
      RepartzoneModels(zoneName: 'Marcory', percentage: 10, valeurExacte: 89, color: const Color(0xFFEF4444)),
      RepartzoneModels(zoneName: 'Cocody', percentage: 37, valeurExacte: 317, color: const Color(0xFFFBBF24)),
    ];
  }
}