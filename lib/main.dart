import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';  
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'telemetry_provider.dart';
import 'config/api_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carrega as variáveis de ambiente
  try {
    await dotenv.load(fileName: ".env");
    print('✅ Arquivo .env carregado com sucesso');
    print('🔑 API Key configurada: ${ApiKeys.hasGoogleMapsApiKey ? 'SIM' : 'NÃO'}');
  } catch (e) {
    print('⚠️ Erro ao carregar .env: $e');
    print('💡 O app funcionará sem API Key (com marca d\'água no mapa)');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TelemetryProvider(),
      child: MaterialApp(
        title: 'Telemetry App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const TelemetryScreen(),
      ),
    );
  }
}

class TelemetryScreen extends StatefulWidget {
  const TelemetryScreen({super.key});

  @override
  State<TelemetryScreen> createState() => _TelemetryScreenState();
}

class _TelemetryScreenState extends State<TelemetryScreen> {
  GoogleMapController? _mapController;
  
   static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-23.5505, -46.6333),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelemetryProvider>().getCurrentLocation();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _centerMapOnCurrentLocation() {
    final provider = context.read<TelemetryProvider>();
    if (provider.currentPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              provider.currentPosition!.latitude,
              provider.currentPosition!.longitude,
            ),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Telemetry App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerMapOnCurrentLocation,
            tooltip: 'Center on current location',
          ),
        ],
      ),
      body: Consumer<TelemetryProvider>(
        builder: (context, telemetryProvider, child) {
          
          Set<Marker> markers = {};
          if (telemetryProvider.currentPosition != null) {
            markers.add(
              Marker(
                markerId: const MarkerId('current_location'),
                position: LatLng(
                  telemetryProvider.currentPosition!.latitude,
                  telemetryProvider.currentPosition!.longitude,
                ),
                infoWindow: InfoWindow(
                  title: 'Current Location',
                  snippet: telemetryProvider.formattedCoordinates,
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            );
          }

          return Column(
            children: [
              
              Expanded(
                flex: 2,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _initialPosition,
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                ),
              ),
              
             
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status: ${telemetryProvider.status}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: telemetryProvider.isTracking 
                                ? Colors.green 
                                : Colors.orange,
                            ),
                          ),
                          Icon(
                            telemetryProvider.isTracking 
                              ? Icons.radio_button_checked 
                              : Icons.radio_button_unchecked,
                            color: telemetryProvider.isTracking 
                              ? Colors.green 
                              : Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                       Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.5,
                          children: [
                            _buildDataCard(
                              'Speed',
                              telemetryProvider.formattedSpeed,
                              Icons.speed,
                              Colors.blue,
                            ),
                            _buildDataCard(
                              'Heading',
                              telemetryProvider.formattedHeading,
                              Icons.navigation,
                              Colors.green,
                            ),
                            _buildDataCard(
                              'Acceleration',
                              telemetryProvider.formattedAcceleration,
                              Icons.trending_up,
                              Colors.orange,
                            ),
                            _buildDataCard(
                              'Location',
                              telemetryProvider.formattedCoordinates,
                              Icons.location_on,
                              Colors.red,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                       Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: telemetryProvider.isTracking
                                ? null
                                : () => telemetryProvider.startTracking(),
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Tracking'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: telemetryProvider.isTracking
                                ? () => telemetryProvider.stopTracking()
                                : null,
                              icon: const Icon(Icons.stop),
                              label: const Text('Stop Tracking'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDataCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}