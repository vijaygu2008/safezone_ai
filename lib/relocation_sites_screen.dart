import 'package:flutter/material.dart';

import 'api_service.dart';
import 'carrying_capacity_screen.dart';

class RelocationSitesScreen extends StatefulWidget {
  const RelocationSitesScreen({super.key});

  @override
  State<RelocationSitesScreen> createState() =>
      _RelocationSitesScreenState();
}

class _RelocationSitesScreenState
    extends State<RelocationSitesScreen> {

  late Future<List<dynamic>> relocationSites;

  @override
  void initState() {
    super.initState();

    relocationSites =
        ApiService.getRelocationSites();
  }

  void refreshSites() {
    setState(() {
      relocationSites =
          ApiService.getRelocationSites();
    });
  }

  void openCarryingCapacity(
      Map<String, dynamic> site) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CarryingCapacityScreen(
              site: site,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relocation Sites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: refreshSites,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder<List<dynamic>>(
        future: relocationSites,

        builder: (context, snapshot) {

          // ------------------------------------------
          // LOADING
          // ------------------------------------------

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ------------------------------------------
          // ERROR
          // ------------------------------------------

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(20),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Unable to load relocation sites',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: refreshSites,
                      icon:
                      const Icon(Icons.refresh),
                      label:
                      const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ------------------------------------------
          // NO DATA
          // ------------------------------------------

          final sites =
              snapshot.data ?? [];

          if (sites.isEmpty) {
            return const Center(
              child: Text(
                'No relocation sites available',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          // ------------------------------------------
          // DATA LOADED
          // ------------------------------------------

          return RefreshIndicator(
            onRefresh: () async {
              refreshSites();
              await relocationSites;
            },

            child: ListView(
              padding:
              const EdgeInsets.all(16),

              children: [

                // HEADER
                Container(
                  padding:
                  const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.blue
                        .withValues(alpha: 0.08),

                    borderRadius:
                    BorderRadius.circular(14),
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 50,
                        height: 50,

                        decoration:
                        BoxDecoration(
                          color: Colors.blue
                              .withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.home_work,
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Safer Relocation Sites',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '${sites.length} suitable sites found',
                              style:
                              const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // SITE CARDS
                for (int index = 0;
                index < sites.length;
                index++)

                  _buildSiteCard(
                    sites[index]
                    as Map<String, dynamic>,
                    index,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSiteCard(
      Map<String, dynamic> site,
      int index) {

    final String name =
        site['name']?.toString() ??
            'Unknown Site';

    final int capacity =
        (site['capacity'] as num?)
            ?.toInt() ??
            0;

    final int safetyScore =
        (site['safety_score'] as num?)
            ?.toInt() ??
            0;

    final double distance =
        (site['distance'] as num?)
            ?.toDouble() ??
            0;

    final double healthcareDistance =
        (site['healthcare_distance']
        as num?)
            ?.toDouble() ??
            0;

    final String road =
        site['road_condition']
            ?.toString() ??
            'Unknown';

    final String hazard =
        site['hazard_exposure']
            ?.toString() ??
            'Unknown';

    final String water =
        site['water']?.toString() ??
            'Unknown';

    final String electricity =
        site['electricity']
            ?.toString() ??
            'Unknown';

    final bool recommended =
        index == 0 &&
            safetyScore >= 90;

    Color safetyColor;

    if (safetyScore >= 90) {
      safetyColor = Colors.green;
    } else if (safetyScore >= 75) {
      safetyColor = Colors.orange;
    } else {
      safetyColor = Colors.red;
    }

    return Card(
      margin:
      const EdgeInsets.only(bottom: 18),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // --------------------------------------
            // RECOMMENDED LABEL
            // --------------------------------------

            if (recommended)
              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: Colors.green
                      .withValues(alpha: 0.12),
                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: const Row(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    Icon(
                      Icons.star,
                      color: Colors.green,
                      size: 17,
                    ),

                    SizedBox(width: 5),

                    Text(
                      'RECOMMENDED SITE',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

            if (recommended)
              const SizedBox(height: 12),

            // --------------------------------------
            // SITE NAME
            // --------------------------------------

            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            // --------------------------------------
            // SAFETY SCORE
            // --------------------------------------

            Container(
              padding:
              const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: safetyColor
                    .withValues(alpha: 0.08),

                borderRadius:
                BorderRadius.circular(10),
              ),

              child: Row(
                children: [

                  Icon(
                    Icons.shield,
                    color: safetyColor,
                    size: 30,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Safety Score',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          '$safetyScore / 100',
                          style: TextStyle(
                            color: safetyColor,
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // --------------------------------------
            // DETAILS
            // --------------------------------------

            _detailRow(
              Icons.people,
              'Capacity',
              '$capacity people',
            ),

            _detailRow(
              Icons.route,
              'Distance',
              '${distance.toStringAsFixed(1)} km',
            ),

            _detailRow(
              Icons.local_hospital,
              'Healthcare',
              '${healthcareDistance.toStringAsFixed(1)} km',
            ),

            _detailRow(
              Icons.directions_car,
              'Road',
              road,
            ),

            _detailRow(
              Icons.warning_amber,
              'Hazard Exposure',
              hazard,
            ),

            _detailRow(
              Icons.water_drop,
              'Water',
              water,
            ),

            _detailRow(
              Icons.bolt,
              'Electricity',
              electricity,
            ),

            const SizedBox(height: 15),

            // --------------------------------------
            // CARRYING CAPACITY BUTTON
            // --------------------------------------

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () {
                  openCarryingCapacity(site);
                },

                icon: const Icon(
                  Icons.assessment,
                ),

                label: const Text(
                  'Assess Carrying Capacity',
                ),

                style:
                ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 14,
                  ),

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(
      IconData icon,
      String title,
      String value) {

    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10),

      child: Row(
        children: [

          Icon(
            icon,
            size: 20,
            color: Colors.grey.shade700,
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          const Spacer(),

          Flexible(
            child: Text(
              value,
              textAlign:
              TextAlign.right,
              style: const TextStyle(
                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}