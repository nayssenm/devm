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
  final CameraPosition _initial = const CameraPosition(target: LatLng(36.8, 10.18), zoom: 12);
  final Map<MarkerId, Marker> _markers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final trajCtrl = context.read<TrajetController>();
    // mettre à jour les marqueurs quand la liste change
    trajCtrl.addListener(() {
      _updateMarkers(trajCtrl.trajets);
    });
    _updateMarkers(trajCtrl.trajets);
  }

  void _updateMarkers(List trajets) {
    _markers.clear();
    for (var t in trajets) {
      final id = MarkerId(t.id);
      final marker = Marker(
        markerId: id,
        position: LatLng(t.depart.latitude, t.depart.longitude),
        infoWindow: InfoWindow(title: t.departAdresse, snippet: '${t.prixParPassager}'),
      );
      _markers[id] = marker;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carte — Trajets')),
      body: GoogleMap(
        initialCameraPosition: _initial,
        onMapCreated: (c) { _mapCtrl = c; },
        markers: Set<Marker>.of(_markers.values),
        myLocationEnabled: true,
      ),
    );
  }
}
