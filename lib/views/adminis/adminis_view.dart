import 'package:flutter/material.dart';

class AdminisView extends StatefulWidget {
  const AdminisView({super.key});

  @override
  State<AdminisView> createState() => _AdminisViewState();
}

class _AdminisViewState extends State<AdminisView> {
  // ============ VARIABLES ============
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'Admin Principal',
      'email': 'admin@cie.ci',
      'role': 'admin',
      'roleLabel': 'admin',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
      'lastLogin': '2026-03-03',
      'icon': Icons.shield,
    },
    {
      'id': 2,
      'name': 'Kouamé Jean',
      'email': 'kouame.j@cie.ci',
      'role': 'superviseur',
      'roleLabel': 'superviseur',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
      'lastLogin': '2026-03-02',
      'icon': Icons.person,
    },
    {
      'id': 3,
      'name': 'Diallo Fatou',
      'email': 'diallo.f@cie.ci',
      'role': 'superviseur',
      'roleLabel': 'superviseur',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
      'lastLogin': '2026-03-01',
      'icon': Icons.person,
    },
    {
      'id': 4,
      'name': 'Traoré Ali',
      'email': 'traore.a@cie.ci',
      'role': 'agent',
      'roleLabel': 'agent',
      'status': 'Actif',
      'statusColor': const Color(0xFFD4F1E4),
      'statusTextColor': const Color(0xFF4CAF50),
      'lastLogin': '2026-03-03',
      'icon': Icons.person,
    },
    {
      'id': 5,
      'name': 'Bamba Moussa',
      'email': 'bamba.m@cie.ci',
      'role': 'agent',
      'roleLabel': 'agent',
      'status': 'Suspendu',
      'statusColor': const Color(0xFFFFEBEE),
      'statusTextColor': const Color(0xFFC62828),
      'lastLogin': '2026-02-20',
      'icon': Icons.person,
    },
  ];

  final List<String> _zones = [
    'Abobo',
    'Yopougon',
    'Cocody',
    'Marcory',
    'Plateau',
    'Treichville',
    'Adjamé',
  ];

  final List<String> _directions = [
    'Abidjan Sud',
    'Abidjan Nord',
    'Bouaké',
    'Yamoussoukro',
    'San Pedro',
    'Korhogo',
  ];

  late List<Map<String, dynamic>> _filteredUsers;

  @override
  void initState() {
    super.initState();
    _filteredUsers = _users;
    _searchController.addListener(_filterUsers);
  }

  // ============ MÉTHODES ============
  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users;
      } else {
        _filteredUsers = _users
            .where((user) =>
        user['name'].toLowerCase().contains(query) ||
            user['email'].toLowerCase().contains(query))
            .toList();
      }
    });
    debugPrint('🔍 Recherche utilisateurs: $query - ${_filteredUsers.length} résultats');
  }

  void _onBackPressed() {
    Navigator.pop(context);
    debugPrint('← Retour cliqué');
  }

  void _onAddUserPressed() {
    debugPrint('➕ Ajouter nouvel utilisateur');
    // TODO: Ouvrir formulaire d'ajout utilisateur
  }

  void _onUserTapped(Map<String, dynamic> user) {
    debugPrint('👤 Utilisateur sélectionné: ${user['name']}');
    // TODO: Ouvrir détails de l'utilisateur
  }

  void _onZoneTapped(String zone) {
    debugPrint('📍 Zone sélectionnée: $zone');
  }

  void _onDirectionTapped(String direction) {
    debugPrint('🏢 Direction sélectionnée: $direction');
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: _onBackPressed,
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: const Text(
          'Administration',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============ TABS ============
            _buildTabsBar(),

            // ============ CONTENU DYNAMIQUE ============
            _selectedTabIndex == 0 ? _buildUtilisateurs() : _buildConfiguration(),
          ],
        ),
      ),
    );
  }

  // ============ WIDGETS HELPER ============

  /// Widget Tabs
  Widget _buildTabsBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: _selectedTabIndex == 0
                      ? Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1.5,
                  )
                      : null,
                ),
                child: Text(
                  'Utilisateurs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: _selectedTabIndex == 0 ? FontWeight.w600 : FontWeight.w500,
                    color: _selectedTabIndex == 0 ? Colors.black : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTabIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: _selectedTabIndex == 1
                      ? Border.all(
                    color: Colors.grey.withValues(alpha: 0.2),
                    width: 1.5,
                  )
                      : null,
                ),
                child: Text(
                  'Configuration',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: _selectedTabIndex == 1 ? FontWeight.w600 : FontWeight.w500,
                    color: _selectedTabIndex == 1 ? Colors.black : Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget Utilisateurs
  Widget _buildUtilisateurs() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Barre de recherche
          Row(
            children: [
              Expanded(
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
                      hintText: 'Rechercher...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _onAddUserPressed,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Liste utilisateurs
          Column(
            children: _filteredUsers.map((user) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _onUserTapped(user),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: Colors.grey[600],
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        user['email'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: user['statusColor'],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                user['status'],
                                style: TextStyle(
                                  color: user['statusTextColor'],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9500).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user['roleLabel'],
                                style: const TextStyle(
                                  color: Color(0xFFFF9500),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Dernière connexion : ${user['lastLogin']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// Widget Configuration
  Widget _buildConfiguration() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zones géographiques
          Text(
            'Zones géographiques',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          Container(
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
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _zones.map((zone) {
                return GestureDetector(
                  onTap: () => _onZoneTapped(zone),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      zone,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),

          // Directions régionales
          Text(
            'Directions régionales',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 14),
          Container(
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
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _directions.map((direction) {
                return GestureDetector(
                  onTap: () => _onDirectionTapped(direction),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      direction,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}