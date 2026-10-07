import 'package:flutter/material.dart';
import 'api_service.dart';
import 'relocation_sites_screen.dart';

class PriorityRankingScreen extends StatefulWidget {
  const PriorityRankingScreen({super.key});

  @override
  State<PriorityRankingScreen> createState() =>
      _PriorityRankingScreenState();
}

class _PriorityRankingScreenState
    extends State<PriorityRankingScreen> {
  List<dynamic> areas = [];
  bool isLoading = true;
  bool usingFallback = false;

  @override
  void initState() {
    super.initState();
    loadPriorityRanking();
  }

  Future<void> loadPriorityRanking() async {
    try {
      final data = await ApiService.getPriorityRanking();

      if (!mounted) return;

      setState(() {
        areas = data;
        isLoading = false;
        usingFallback = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        areas = fallbackAreas;
        isLoading = false;
        usingFallback = true;
      });
    }
  }

  final List<Map<String, dynamic>> fallbackAreas = [
    {
      'rank': 1,
      'name': 'Critical Zone',
      'risk': 92,
      'population': 1240,
      'vulnerability': 'Very High',
      'priority': 'Immediate Relocation',
    },
    {
      'rank': 2,
      'name': 'High Risk Area',
      'risk': 84,
      'population': 980,
      'vulnerability': 'High',
      'priority': 'Immediate Attention',
    },
    {
      'rank': 3,
      'name': 'Mountain Village',
      'risk': 76,
      'population': 720,
      'vulnerability': 'High',
      'priority': 'Short-Term Relocation',
    },
    {
      'rank': 4,
      'name': 'River Side Habitation',
      'risk': 68,
      'population': 560,
      'vulnerability': 'Moderate',
      'priority': 'Monitor Closely',
    },
    {
      'rank': 5,
      'name': 'Hill Settlement',
      'risk': 54,
      'population': 430,
      'vulnerability': 'Moderate',
      'priority': 'Preparedness Required',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Priority Ranking',
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

              loadPriorityRanking();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: loadPriorityRanking,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            const Text(
              'Relocation Priority',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Habitations are ranked based on risk, population exposure and vulnerability.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            if (usingFallback)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.orange.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_off,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Backend unavailable. Showing demo priority data.',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            ...areas.map(
                  (area) => _priorityCard(
                context,
                Map<String, dynamic>.from(area),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: Colors.blue.shade50,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Priority Calculation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Priority is determined using a combination of hazard risk, population exposure and vulnerability factors.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Higher risk and higher vulnerability result in a higher relocation priority.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const RelocationSitesScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.home_work),
                label: const Text(
                  'FIND RELOCATION SITES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _priorityCard(
      BuildContext context,
      Map<String, dynamic> area,
      ) {
    final int rank =
    (area['rank'] ?? 0) as int;

    final int risk =
    (area['risk'] ?? 0) as int;

    final int population =
    (area['population'] ?? 0) as int;

    final String name =
        area['name']?.toString() ?? 'Unknown Area';

    final String vulnerability =
        area['vulnerability']?.toString() ?? 'Unknown';

    final String priority =
        area['priority']?.toString() ?? 'Unknown';

    Color riskColor;

    if (risk >= 81) {
      riskColor = Colors.red;
    } else if (risk >= 61) {
      riskColor = Colors.orange;
    } else {
      riskColor = Colors.amber.shade700;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                CircleAvatar(
                  radius: 23,
                  backgroundColor: riskColor,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: riskColor,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$risk / 100',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [

                Expanded(
                  child: _info(
                    Icons.people,
                    'Population',
                    '$population',
                  ),
                ),

                Expanded(
                  child: _info(
                    Icons.warning_amber,
                    'Vulnerability',
                    vulnerability,
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              children: [
                const Icon(
                  Icons.priority_high,
                  color: Colors.red,
                  size: 22,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    priority,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [

        Icon(
          icon,
          size: 20,
          color: Colors.blue,
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}