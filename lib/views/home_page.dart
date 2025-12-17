import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devm_covoitlocal/controllers/auth_controller.dart';
import 'package:devm_covoitlocal/controllers/trajet_controller.dart';
import 'package:devm_covoitlocal/views/map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  // Méthode pour formater la date sans intl
  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
  
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final trajetCtrl = context.watch<TrajetController>();
    
    // Couleurs du thème
    final Color primaryGrey = const Color(0xFF3A3A3A);
    final Color secondaryBeige = const Color(0xFFF5F1E8);
    final Color accentBlue = const Color(0xFF4A6FA5);
    final Color lightBlue = const Color(0xFF7B9BC9);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CovoitLocal',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: primaryGrey,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                auth.signOut().then((_) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                  Navigator.of(context).pushReplacementNamed('/');
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Déconnexion'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: secondaryBeige,
        child: Column(
          children: [
            // En-tête utilisateur
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: accentBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            auth.user?.nom.isNotEmpty == true 
                              ? auth.user!.nom[0].toUpperCase() 
                              : 'U',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour, ${auth.user?.nom ?? 'Utilisateur'}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: primaryGrey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              auth.user?.email ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: primaryGrey.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accentBlue, lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: accentBlue.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MapPage()),
                          ),
                          icon: const Icon(Icons.map, color: Colors.white, size: 20),
                          label: const Text(
                            'Voir la carte',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Statistiques
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                        icon: Icons.directions_car,
                        value: trajetCtrl.trajets.length.toString(),
                        label: 'Trajets',
                        color: accentBlue,
                      ),
                      _buildStatCard(
                        icon: Icons.people,
                        value: _countUserReservations(trajetCtrl, auth.user?.uid),
                        label: 'Réservations',
                        color: Colors.green,
                      ),
                      _buildStatCard(
                        icon: Icons.star,
                        value: auth.user?.noteMoyenne.toStringAsFixed(1) ?? '0.0',
                        label: 'Note',
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Titre section trajets
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trajets disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primaryGrey,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${trajetCtrl.trajets.length} disponibles',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Liste des trajets
            Expanded(
              child: trajetCtrl.loading && trajetCtrl.trajets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: accentBlue),
                          const SizedBox(height: 16),
                          Text(
                            'Chargement des trajets...',
                            style: TextStyle(color: primaryGrey.withOpacity(0.6)),
                          ),
                        ],
                      ),
                    )
                  : trajetCtrl.trajets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.directions_car_outlined,
                                size: 80,
                                color: primaryGrey.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun trajet disponible',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryGrey.withOpacity(0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Soyez le premier à proposer un trajet !',
                                style: TextStyle(
                                  color: primaryGrey.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  // Naviguer vers création de trajet
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentBlue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                ),
                                child: const Text('Proposer un trajet'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: accentBlue,
                          onRefresh: () async {
                            // Simule un refresh
                            await Future.delayed(const Duration(milliseconds: 500));
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: trajetCtrl.trajets.length,
                            itemBuilder: (ctx, i) {
                              final t = trajetCtrl.trajets[i];
                              
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // En-tête du trajet
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: t.statut == 'actif' && t.placesDisponibles > 0
                                            ? accentBlue.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: t.statut == 'actif' && t.placesDisponibles > 0
                                                  ? accentBlue
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.directions_car,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${t.departAdresse} → ${t.arriveeAdresse}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryGrey,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatDateTime(t.dateHeure),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: primaryGrey.withOpacity(0.6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: t.statut == 'actif' && t.placesDisponibles > 0
                                                  ? Colors.green.withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: t.statut == 'actif' && t.placesDisponibles > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            child: Text(
                                              t.statut == 'actif' && t.placesDisponibles > 0
                                                  ? 'Disponible'
                                                  : 'Complet',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: t.statut == 'actif' && t.placesDisponibles > 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Détails du trajet
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailRow(
                                                  icon: Icons.access_time,
                                                  text: _formatTime(t.dateHeure),
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(height: 8),
                                                _buildDetailRow(
                                                  icon: Icons.attach_money,
                                                  text: '${t.prixParPassager} DT',
                                                  color: Colors.green,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                _buildDetailRow(
                                                  icon: Icons.people,
                                                  text: '${t.placesDisponibles} places',
                                                  color: t.placesDisponibles > 0
                                                      ? accentBlue
                                                      : Colors.red,
                                                ),
                                                const SizedBox(height: 8),
                                                _buildDetailRow(
                                                  icon: Icons.person,
                                                  text: '${t.passagersIds.length} passagers',
                                                  color: Colors.purple,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Bouton de réservation
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: t.statut == 'actif' && t.placesDisponibles > 0
                                              ? () {
                                                  final uid = auth.user?.uid;
                                                  if (uid == null) {
                                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Veuillez vous connecter d\'abord'),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  // Vérifier si l'utilisateur est déjà passager
                                                  if (t.passagersIds.contains(uid)) {
                                                    ScaffoldMessenger.of(ctx).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Vous avez déjà réservé ce trajet'),
                                                        backgroundColor: Colors.orange,
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  trajetCtrl.reserver(t.id, uid);
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: t.statut == 'actif' && t.placesDisponibles > 0
                                                ? accentBlue
                                                : Colors.grey,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.bookmark_add, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                t.statut == 'actif' && t.placesDisponibles > 0
                                                    ? 'Réserver maintenant'
                                                    : 'Trajet complet',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Naviguer vers création de trajet
        },
        backgroundColor: accentBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nouveau trajet',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Méthode pour compter les réservations de l'utilisateur
  String _countUserReservations(TrajetController trajetCtrl, String? userId) {
    if (userId == null) return '0';
    
    int count = 0;
    for (var trajet in trajetCtrl.trajets) {
      if (trajet.passagersIds.contains(userId)) {
        count++;
      }
    }
    return count.toString();
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}