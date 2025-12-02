import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devm_covoitlocal/controllers/auth_controller.dart';
import 'package:devm_covoitlocal/controllers/trajet_controller.dart';
import 'package:devm_covoitlocal/views/map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final trajetCtrl = context.watch<TrajetController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CovoitLocal'),
        actions: [
          IconButton(onPressed: () => auth.signOut().then((_) {
            Navigator.of(context).popUntil((r) => r.isFirst);
            Navigator.of(context).pushReplacementNamed('/');
          }), icon: const Icon(Icons.logout),),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            CircleAvatar(child: Text(auth.user?.nom.isNotEmpty == true ? auth.user!.nom[0] : 'U')),
            const SizedBox(width: 12),
            Expanded(child: Text('Bonjour, ${auth.user?.nom ?? 'Utilisateur'}')),
            ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MapPage())),
                icon: const Icon(Icons.map), label: const Text('Carte'),
            ),
          ],),
        ),
        const Divider(),
        Expanded(
          child: trajetCtrl.loading ? const Center(child: CircularProgressIndicator()) :
          ListView.builder(
            itemCount: trajetCtrl.trajets.length,
            itemBuilder: (ctx, i) {
              final t = trajetCtrl.trajets[i];
              return ListTile(
                title: Text('${t.departAdresse} → ${t.arriveeAdresse}'),
                subtitle: Text('Le ${t.dateHeure} • ${t.placesDisponibles} places • ${t.prixParPassager}'),
                trailing: ElevatedButton(
                  child: const Text('Réserver'),
                  onPressed: () {
                    final uid = auth.user?.uid;
                    if (uid == null) {
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Connecte toi d\'abord')));
                      return;
                    }
                    trajetCtrl.reserver(t.id, uid);
                  },
                ),
              );
            },
          ),
        ),
      ],),
    );
  }
}
