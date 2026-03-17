import 'package:flutter/material.dart';
import '../models/gadget_model.dart';

class GadgetData {
  static List<GadgetModel> getGadgets() {
    return [
      GadgetModel(
        id: 1,
        name: 'T-shirt CIE',
        category: 'Textile',
        enStock: 250,
        distribues: 180,
        total: 430,
        icon: Icons.checkroom,
      ),
      GadgetModel(
        id: 2,
        name: 'Casquette CIE',
        category: 'Textile',
        enStock: 45,
        distribues: 155,
        total: 200,
        statusBadge: 'Stock bas',
        statusColor: const Color(0xFFFFEBEE),
        statusTextColor: const Color(0xFFC62828),
        icon: Icons.checkroom,
      ),
      GadgetModel(
        id: 3,
        name: 'Stylo CIE',
        category: 'Fourniture',
        enStock: 500,
        distribues: 1200,
        total: 1700,
        icon: Icons.edit,
      ),
      GadgetModel(
        id: 4,
        name: 'Bloc-notes CIE',
        category: 'Fourniture',
        enStock: 120,
        distribues: 380,
        total: 500,
        icon: Icons.note,
      ),
      GadgetModel(
        id: 5,
        name: 'Sac CIE',
        category: 'Accessoire',
        enStock: 80,
        distribues: 220,
        total: 300,
        icon: Icons.shopping_bag,
      ),
    ];
  }
}