import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<String> obtenerUbicacion() async {
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      return 'El servicio de ubicación está desactivado.';
    }

    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();

      if (permiso == LocationPermission.denied) {
        return 'Permiso de ubicación denegado.';
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      return 'El permiso de ubicación está bloqueado en la configuración.';
    }

    final posicion = await Geolocator.getCurrentPosition();

    return 'Latitud: ${posicion.latitude}\n'
        'Longitud: ${posicion.longitude}';
  }

  Future<void> detenerUbicacion() async {
    // No mantenemos una ubicación activa.
    // Por eso no hay seguimiento que detener.
  }
}