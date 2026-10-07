import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'api_service.dart';
import 'risk_details_screen.dart';

class RiskMapScreen extends StatefulWidget {
  const RiskMapScreen({super.key});

  @override
  State<RiskMapScreen> createState() =>
      _RiskMapScreenState();
}

class _RiskMapScreenState extends State<RiskMapScreen> {
  List<dynamic> locations = [];
  bool isLoading = true;
  bool usingFallback = false;

  final List<Map<String, dynamic>> fallbackLocations = [
    {
      'id': 1,
      'name': 'Critical Zone',
      'latitude': 11.4102,
      'longitude': 76.6950,
      'risk_score': 92,
      'population': 1240,
      'risk_level': 'Critical',
      'hazards': ['Flood', 'Landslide'],
      'priority': 'Immediate Relocation',
    },
    {
      'id': 2,
      'name': 'High Risk Area',
      'latitude': 11.4300,
      'longitude': 76.7200,
      'risk_score': 74,
      'population': 860,
      'risk_level': 'High',
      'hazards': ['Heavy Rainfall', 'Landslide'],
      'priority': 'Short-Term Relocation',
    },
    {
      'id': 3,
      'name': 'Safe Relocation Site',
      'latitude': 11.3900,
      'longitude': 76.6800,
      'risk_score': 12,
      'population': 1500,
      'risk_level': 'Low',
      'hazards': ['Low Hazard Exposure'],
      'priority': 'Suitable for Relocation',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadRiskMap();
  }

  Future<void> loadRiskMap() async {
    try {
      final data = await ApiService.getRiskMap();

      if (!mounted) return;

      setState(() {
        locations = data;
        isLoading = false;
        usingFallback = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        locations = fallbackLocations;
        isLoading = false;
        usingFallback = true;
      });
    }
  }

  Color getRiskColor(int risk) {
    if (risk >= 81) {
      return Colors.red;
    }

    if (risk >= 61) {
      return Colors.orange;
    }

    return Colors.green;
  }

  List<String> getHazards(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item.toString())
          .toList();
    }

    if (value == null) {
      return [];
    }

    return [value.toString()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Risk Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });

              loadRiskMap();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [

          FlutterMap(
            options: const MapOptions(
              initialCenter:
              LatLng(11.4102, 76.6950),
              initialZoom: 12,
            ),

            children: [

              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                'com.example.safezone_ai',
              ),

              MarkerLayer(
                markers: locations.map((location) {

                  final double latitude =
                  (location['latitude'] as num)
                      .toDouble();

                  final double longitude =
                  (location['longitude'] as num)
                      .toDouble();

                  final int risk =
                  (location['risk_score'] as num)
                      .toInt();

                  return Marker(
                    point: LatLng(
                      latitude,
                      longitude,
                    ),
                    width: 70,
                    height: 70,
                    child: GestureDetector(
                      onTap: () {

                        final hazards =
                        getHazards(
                          location['hazards'],
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RiskDetailsScreen(
                                  areaName:
                                  location['name']
                                      .toString(),
                                  riskScore: risk,
                                  population:
                                  (location['population']
                                  as num)
                                      .toInt(),
                                  hazards: hazards,
                                  priority:
                                  location['priority']
                                      .toString(),
                                ),
                          ),
                        );
                      },

                      child: Icon(
                        Icons.location_on,
                        color:
                        getRiskColor(risk),
                        size: 55,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          if (usingFallback)
            Positioned(
              top: 10,
              left: 10,
              right: 10,
              child: Container(
                padding:
                const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                  Colors.orange.shade50,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: const Text(
                  'Backend unavailable. Showing demo map data.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 15,
            child: Card(
              elevation: 4,
              child: Padding(
                padding:
                const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    _legend(
                      Colors.red,
                      'Critical',
                    ),

                    _legend(
                      Colors.orange,
                      'High',
                    ),

                    _legend(
                      Colors.green,
                      'Low / Safe',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(
      Color color,
      String text,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [

          Icon(
            Icons.location_on,
            color: color,
            size: 20,
          ),

          const SizedBox(width: 6),

          Text(text),
        ],
      ),
    );
  }
}