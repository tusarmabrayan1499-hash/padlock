import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationService _locationService = LocationService();

  String mensajeUbicacion = 'Ubicación no consultada';

  Future<void> obtenerUbicacion() async {
    final resultado = await _locationService.obtenerUbicacion();

    if (!mounted) return;

    setState(() {
      mensajeUbicacion = resultado;
    });
  }

  Future<void> cerrarSesion() async {
    await _locationService.detenerUbicacion();

    if (!mounted) return;

    await Provider.of<AuthProvider>(context, listen: false).cerrarSesion();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<AuthProvider>(context).usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Padlock'),
        actions: [
          IconButton(
            onPressed: cerrarSesion,
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(usuario?.nombre ?? ''),
                subtitle: Text(usuario?.correo ?? ''),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Recurso del dispositivo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: obtenerUbicacion,
              icon: const Icon(Icons.location_on),
              label: const Text('Solicitar ubicación'),
            ),

            const SizedBox(height: 15),

            Text(mensajeUbicacion),
          ],
        ),
      ),
    );
  }
}