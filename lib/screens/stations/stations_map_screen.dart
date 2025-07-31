import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';

class StationsMapScreen extends StatefulWidget {
  const StationsMapScreen({super.key});

  @override
  State<StationsMapScreen> createState() => _StationsMapScreenState();
}

class _StationsMapScreenState extends State<StationsMapScreen> {
  final String mapUrl = 'https://www.google.com/maps/d/viewer?mid=1hSpdBce3ITX4CySXQMp79Jj285LeB_w&ll=24.64657798555033%2C44.64840154921877&z=7';
  
  final List<StationLocation> stations = [
    StationLocation(name: 'FuelApp Station - Riyadh', lat: 24.7136, lng: 46.6753, distance: '2.25 km'),
    StationLocation(name: 'FuelApp Station - Jeddah', lat: 21.4858, lng: 39.1925, distance: '12.5 km'),
    StationLocation(name: 'FuelApp Station - Dammam', lat: 26.4207, lng: 50.0888, distance: '18.9 km'),
    StationLocation(name: 'FuelApp Station - Makkah', lat: 21.4225, lng: 39.8262, distance: '103 km'),
    StationLocation(name: 'FuelApp Station - Madinah', lat: 24.5247, lng: 39.5692, distance: '120 km'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Stations locations'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter options would be implemented here')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildMapView(),
          Positioned(
            top: 16,
            right: 16,
            child: _buildMapTypeButton(),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Stations Locations Page (Does Page Load for All the Stations except SASCO Outlet)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: stations.length,
                        itemBuilder: (context, index) {
                          return _buildStationItem(stations[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildMapView() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
          ),
          child: CustomPaint(
            size: Size.infinite,
            painter: MapPainter(stations: stations),
          ),
        ),
        ...stations.map((station) {
          return Positioned(
            left: (MediaQuery.of(context).size.width * station.lng / 180) + 100,
            top: (MediaQuery.of(context).size.height * (90 - station.lat) / 180) + 50,
            child: GestureDetector(
              onTap: () => _openGoogleMaps(station),
              child: _buildMapMarker(station.name),
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildMapMarker(String name) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_gas_station,
        color: Colors.white,
        size: 30,
      ),
    );
  }
  
  Widget _buildMapTypeButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.layers, color: AppTheme.primaryColor),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('Default'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.satellite),
                    title: const Text('Satellite'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.terrain),
                    title: const Text('Terrain'),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStationItem(StationLocation station) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.local_gas_station,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          station.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Distance: ${station.distance}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.directions, color: AppTheme.primaryColor),
          onPressed: () => _openGoogleMaps(station),
        ),
      ),
    );
  }
  
  void _openGoogleMaps(StationLocation station) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions to ${station.name}'),
        action: SnackBarAction(
          label: 'View Map',
          onPressed: () {
            // In a real app, this would open the actual Google Maps URL
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Open Google Maps'),
                content: Text('Would open: $mapUrl\n\nDirections to: ${station.name}\nCoordinates: ${station.lat}, ${station.lng}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class StationLocation {
  final String name;
  final double lat;
  final double lng;
  final String distance;
  
  StationLocation({
    required this.name,
    required this.lat,
    required this.lng,
    required this.distance,
  });
}

class MapPainter extends CustomPainter {
  final List<StationLocation> stations;
  
  MapPainter({required this.stations});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    // Draw some map-like shapes
    final path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.2,
      size.width * 0.5, size.height * 0.35,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.5,
      size.width, size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}