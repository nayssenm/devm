import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:devm_covoitlocal/controllers/trajet_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapCtrl;
  final CameraPosition _initial = const CameraPosition(
    target: LatLng(36.8, 10.18),
    zoom: 12,
  );
  final Map<MarkerId, Marker> _markers = {};
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  
  // Couleurs du thème
  final Color _primaryGrey = const Color(0xFF3A3A3A);
  final Color _secondaryBeige = const Color(0xFFF5F1E8);
  final Color _accentBlue = const Color(0xFF4A6FA5);
  final Color _lightBlue = const Color(0xFF7B9BC9);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final trajCtrl = context.read<TrajetController>();
    
    // Mettre à jour les marqueurs quand la liste change
    trajCtrl.addListener(() {
      _updateMarkers(trajCtrl.trajets);
    });
    
    _updateMarkers(trajCtrl.trajets);
  }

  void _updateMarkers(List trajets) {
    _markers.clear();
    
    for (var t in trajets) {
      final id = MarkerId(t.id?.toString() ?? '${t.hashCode}');
      
      // Utilisez les champs disponibles dans votre TrajetModel
      // Adaptez ces lignes selon votre modèle réel
      final hasPlaces = t.nbPlaces != null && t.nbPlaces! > 0; // ou t.placesDisponibles, t.nombreDePlaces, etc.
      final prix = t.prix?.toString() ?? t.tarif?.toString() ?? 'N/A';
      final adresse = t.departAdresse ?? t.lieuDepart ?? 'Non spécifié';
      
      final marker = Marker(
        markerId: id,
        position: LatLng(
          t.depart?.latitude ?? 36.8, // Adaptez selon votre structure
          t.depart?.longitude ?? 10.18,
        ),
        infoWindow: InfoWindow(
          title: adresse,
          snippet: '$prix DT', // Utilisez le champ prix de votre modèle
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          hasPlaces 
            ? BitmapDescriptor.hueAzure  // Bleu pour places disponibles
            : BitmapDescriptor.hueRed,    // Rouge pour complet
        ),
        onTap: () {
          _showTrajetDetails(context, t);
        },
      );
      _markers[id] = marker;
    }
    
    setState(() {});
  }

  void _showTrajetDetails(BuildContext context, dynamic trajet) {
    // Récupérez les données selon votre modèle réel
    final adresseDepart = trajet.departAdresse ?? trajet.lieuDepart ?? 'Non spécifié';
    final adresseArrivee = trajet.arriveeAdresse ?? trajet.lieuArrivee ?? 'Non spécifié';
    final prix = trajet.prix ?? trajet.tarif ?? 0;
    final heure = trajet.heureDepart ?? trajet.heure ?? '--:--';
    final conducteur = trajet.conducteurNom ?? trajet.nomConducteur ?? 'Conducteur';
    final note = trajet.conducteurNote ?? 5.0;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: _secondaryBeige,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _primaryGrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Adresse de départ
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      adresseDepart,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _primaryGrey,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Adresse d'arrivée
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      adresseArrivee,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _primaryGrey,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Informations détaillées
              Row(
                children: [
                  _buildDetailChip(
                    icon: Icons.attach_money,
                    text: '$prix DT',
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    icon: Icons.access_time,
                    text: heure,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  // Si vous avez un champ pour les places, décommentez ceci
                  // _buildDetailChip(
                  //   icon: Icons.people,
                  //   text: '${trajet.nbPlaces ?? 0} places',
                  //   color: _accentBlue,
                  // ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Information conducteur
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conducteur,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _primaryGrey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '★ ${note.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Bouton de réservation
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Action de réserver
                    Navigator.pop(context);
                    _showReservationDialog(context, trajet);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Réserver ce trajet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReservationDialog(BuildContext context, dynamic trajet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la réservation'),
        content: Text('Voulez-vous réserver le trajet vers ${trajet.departAdresse ?? "cette destination"} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Ajoutez ici la logique de réservation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentBlue,
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String text, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _primaryGrey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trajCtrl = context.watch<TrajetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carte des Trajets',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: _primaryGrey,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initial,
            onMapCreated: (controller) {
              _mapCtrl = controller;
            },
            markers: Set<Marker>.of(_markers.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // On ajoute notre propre bouton
            zoomControlsEnabled: false,
          ),
          
          // Barre de recherche
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Rechercher un lieu...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Vous pouvez ajouter la logique de filtrage ici
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Panneau d'information
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _secondaryBeige.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trajCtrl.trajets.length} Trajets disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _primaryGrey,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  if (trajCtrl.trajets.isEmpty)
                    const Center(
                      child: Text(
                        'Aucun trajet disponible pour le moment',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trajCtrl.trajets.length,
                        itemBuilder: (context, index) {
                          final trajet = trajCtrl.trajets[index];
                          final adresse = trajet.departAdresse ?? 'Trajet ${index + 1}';
                          final prix = trajet.prixParPassager.toString() ?? 'N/A';
                          
                          return GestureDetector(
                            onTap: () {
                              // Centre la carte sur ce trajet
                              _mapCtrl?.animateCamera(
                                CameraUpdate.newLatLng(
                                  LatLng(
                                    trajet.depart.latitude,
                                    trajet.depart.longitude,
                                  ),
                                ),
                              );
                                                          _showTrajetDetails(context, trajet);
                            },
                            child: Container(
                              width: 200,
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _accentBlue.withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    adresse.length > 30 
                                      ? '${adresse.substring(0, 30)}...' 
                                      : adresse,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _primaryGrey,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$prix DT',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _accentBlue,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: _accentBlue,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Bouton de localisation
          Positioned(
            bottom: 160,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _mapCtrl?.animateCamera(
                  CameraUpdate.newLatLngZoom(const LatLng(36.8, 10.18), 12),
                );
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.my_location, color: _accentBlue),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigation vers la page de création de trajet
        },
        backgroundColor: _accentBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nouveau trajet',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}