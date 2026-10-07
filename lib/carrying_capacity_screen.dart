import 'package:flutter/material.dart';

class CarryingCapacityScreen extends StatelessWidget {
  final Map<String, dynamic> site;

  const CarryingCapacityScreen({
    super.key,
    required this.site,
  });

  // ============================================================
  // GET VALUES
  // ============================================================

  int get capacity {
    return (site['capacity'] as num?)?.toInt() ?? 0;
  }

  int get affectedPopulation {
    // Current affected population from our risk API
    return 1240;
  }

  int get availableCapacity {
    final result =
        capacity - affectedPopulation;

    return result > 0 ? result : 0;
  }

  int get suitabilityScore {
    final score =
        (site['safety_score'] as num?)
            ?.toInt() ??
            0;

    return score;
  }

  String get siteName {
    return site['name']?.toString() ??
        'Unknown Site';
  }

  String get roadCondition {
    return site['road_condition']
        ?.toString() ??
        'Unknown';
  }

  String get water {
    return site['water']?.toString() ??
        'Unknown';
  }

  String get electricity {
    return site['electricity']
        ?.toString() ??
        'Unknown';
  }

  String get hazardExposure {
    return site['hazard_exposure']
        ?.toString() ??
        'Unknown';
  }

  double get healthcareDistance {
    return (site['healthcare_distance']
    as num?)
        ?.toDouble() ??
        0;
  }

  // ============================================================
  // SUITABILITY COLOR
  // ============================================================

  Color getSuitabilityColor() {
    if (suitabilityScore >= 90) {
      return Colors.green;
    }

    if (suitabilityScore >= 75) {
      return Colors.orange;
    }

    return Colors.red;
  }

  // ============================================================
  // CONFIRM RELOCATION
  // ============================================================

  void confirmRelocation(
      BuildContext context,
      ) {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirm Relocation Site',
          ),

          content: Text(
            '$siteName has been selected as a suitable relocation site.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Relocation site confirmed successfully',
                    ),
                  ),
                );
              },

              child: const Text(
                'Confirm',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Carrying Capacity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // ==================================================
            // SITE NAME
            // ==================================================

            Card(
              elevation: 3,

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Row(
                  children: [
                    const Icon(
                      Icons.location_city,
                      size: 40,
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          const Text(
                            'Relocation Site',
                            style: TextStyle(
                              fontSize: 13,
                              color:
                              Colors.grey,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(
                            siteName,
                            style:
                            const TextStyle(
                              fontSize: 19,
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
            ),

            const SizedBox(height: 16),

            // ==================================================
            // CAPACITY OVERVIEW
            // ==================================================

            const Text(
              'Capacity Assessment',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: capacityCard(
                    'Affected Population',
                    affectedPopulation,
                    Icons.people,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: capacityCard(
                    'Site Capacity',
                    capacity,
                    Icons.home_work,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 3,

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Row(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 32,
                      color:
                      availableCapacity > 0
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    const Expanded(
                      child: Text(
                        'Available Capacity',
                        style: TextStyle(
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    Text(
                      '$availableCapacity',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        availableCapacity >
                            0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // SUITABILITY
            // ==================================================

            const Text(
              'Site Suitability',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 3,

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shield,
                          size: 35,
                          color:
                          getSuitabilityColor(),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        const Expanded(
                          child: Text(
                            'Suitability Score',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),

                        Text(
                          '$suitabilityScore/100',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            getSuitabilityColor(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    LinearProgressIndicator(
                      value:
                      suitabilityScore /
                          100,

                      minHeight: 10,

                      borderRadius:
                      BorderRadius
                          .circular(
                        10,
                      ),

                      color:
                      getSuitabilityColor(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // INFRASTRUCTURE
            // ==================================================

            const Text(
              'Infrastructure Assessment',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 3,

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Column(
                  children: [
                    assessmentRow(
                      Icons.water_drop,
                      'Water',
                      water,
                    ),

                    assessmentRow(
                      Icons.local_hospital,
                      'Healthcare',
                      '${healthcareDistance.toStringAsFixed(1)} km',
                    ),

                    assessmentRow(
                      Icons.route,
                      'Road',
                      roadCondition,
                    ),

                    assessmentRow(
                      Icons.bolt,
                      'Electricity',
                      electricity,
                    ),

                    assessmentRow(
                      Icons.warning_amber,
                      'Hazard Exposure',
                      hazardExposure,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // RECOMMENDATION
            // ==================================================

            Card(
              elevation: 3,

              color:
              suitabilityScore >= 90
                  ? Colors.green
                  .withValues(
                alpha: 0.1,
              )
                  : Colors.orange
                  .withValues(
                alpha: 0.1,
              ),

              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Icon(
                      suitabilityScore >= 90
                          ? Icons.check_circle
                          : Icons.info,
                      color:
                      suitabilityScore >= 90
                          ? Colors.green
                          : Colors.orange,
                      size: 30,
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child: Text(
                        suitabilityScore >= 90
                            ? 'This site is highly suitable for relocation based on capacity, safety, infrastructure and low hazard exposure.'
                            : 'This site may be suitable, but additional assessment is recommended before relocation.',
                        style:
                        const TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // CONFIRM BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed:
                availableCapacity > 0
                    ? () {
                  confirmRelocation(
                    context,
                  );
                }
                    : null,

                icon: const Icon(
                  Icons.check_circle,
                ),

                label: const Text(
                  'Confirm Relocation Site',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                style:
                ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CAPACITY CARD
  // ============================================================

  Widget capacityCard(
      String title,
      int value,
      IconData icon,
      ) {
    return Card(
      elevation: 3,

      child: Padding(
        padding:
        const EdgeInsets.all(15),

        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              '$value',
              style: const TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              title,
              textAlign:
              TextAlign.center,

              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ASSESSMENT ROW
  // ============================================================

  Widget assessmentRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 9,
      ),

      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
          ),

          const SizedBox(
            width: 12,
          ),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight:
                FontWeight.w500,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}