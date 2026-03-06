import 'package:flutter/material.dart';

class GadgetsView extends StatefulWidget {
  const GadgetsView({super.key});

  @override
  State<GadgetsView> createState() => _GadgetsViewState();
}

class _GadgetsViewState extends State<GadgetsView> {
  // ============ CONTROLLERS ============
  final TextEditingController _searchController = TextEditingController();

  // ============ DATA ============
  final List<Map<String, dynamic>> _allGadgets = [
    {
      'id': 1,
      'name': 'T-shirt CIE',
      'category': 'Textile',
      'enStock': 250,
      'distribues': 180,
      'total': 430,
      'statusBadge': null,
      'statusColor': null,
      'statusTextColor': null,
      'icon': Icons.checkroom,
    },
    {
      'id': 2,
      'name': 'Casquette CIE',
      'category': 'Textile',
      'enStock': 45,
      'distribues': 155,
      'total': 200,
      'statusBadge': 'Stock bas',
      'statusColor': const Color(0xFFFFEBEE),
      'statusTextColor': const Color(0xFFC62828),
      'icon': Icons.checkroom,
    },
    {
      'id': 3,
      'name': 'Stylo CIE',
      'category': 'Fourniture',
      'enStock': 500,
      'distribues': 1200,
      'total': 1700,
      'statusBadge': null,
      'statusColor': null,
      'statusTextColor': null,
      'icon': Icons.edit,
    },
    {
      'id': 4,
      'name': 'Bloc-notes CIE',
      'category': 'Fourniture',
      'enStock': 120,
      'distribues': 380,
      'total': 500,
      'statusBadge': null,
      'statusColor': null,
      'statusTextColor': null,
      'icon': Icons.note,
    },
    {
      'id': 5,
      'name': 'Sac CIE',
      'category': 'Accessoire',
      'enStock': 80,
      'distribues': 220,
      'total': 300,
      'statusBadge': null,
      'statusColor': null,
      'statusTextColor': null,
      'icon': Icons.shopping_bag,
    },
  ];

  late List<Map<String, dynamic>> _filteredGadgets;

  @override
  void initState() {
    super.initState();
    _filteredGadgets = _allGadgets;
    _searchController.addListener(_filterGadgets);
  }

  // ============ MÉTHODES ============
  void _filterGadgets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredGadgets = _allGadgets;
      } else {
        _filteredGadgets = _allGadgets
            .where((gadget) =>
        gadget['name'].toLowerCase().contains(query) ||
            gadget['category'].toLowerCase().contains(query))
            .toList();
      }
    });
    debugPrint('🔍 Recherche: $query - ${_filteredGadgets.length} résultats');
  }

  void _onScannerPressed() {
    debugPrint('📱 Scanner QR - Lancer scan');
    // TODO: Implémenter le scanner QR
  }

  void _onGadgetTapped(Map<String, dynamic> gadget) {
    debugPrint('📦 Gadget sélectionné: ${gadget['name']}');
    // TODO: Ouvrir détails du gadget
  }

  double _calculateStockPercentage(int enStock, int total) {
    return total > 0 ? enStock / total : 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ============ APP BAR PERSONNALISÉ ============
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            expandedHeight: 80,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gadgets',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: _onScannerPressed,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9500),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // <-- CRUCIAL POUR LE BOUTON SCANNER
                          children: const [
                            Icon(
                              Icons.qr_code,
                              color: Colors.white,
                              size: 10,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Scanner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10
                                ,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: false,
            ),
          ),

          // ============ BARRE DE RECHERCHE ============
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un gadget...',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ============ LISTE DES GADGETS ============
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final gadget = _filteredGadgets[index];
                  final stockPercentage =
                  _calculateStockPercentage(gadget['enStock'], gadget['total']);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GestureDetector(
                      onTap: () => _onGadgetTapped(gadget),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ============ HEADER: ICON + NOM + BADGE ============
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9500).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    gadget['icon'],
                                    color: const Color(0xFFFF9500),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Nom + Catégorie
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        gadget['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        gadget['category'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Badge Status
                                if (gadget['statusBadge'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: gadget['statusColor'],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // <-- CRUCIAL POUR LE BADGE
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: gadget['statusTextColor'],
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          gadget['statusBadge'],
                                          style: TextStyle(
                                            color: gadget['statusTextColor'],
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // ============ EN STOCK + DISTRIBUÉS ============
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          gadget['enStock'].toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'En stock',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          gadget['distribues'].toString(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Distribués',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ============ BARRE DE PROGRESS ============
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Stock',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${gadget['enStock']} / ${gadget['total']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: stockPercentage,
                                minHeight: 8,
                                backgroundColor: const Color(0xFFFF9500),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _filteredGadgets.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}