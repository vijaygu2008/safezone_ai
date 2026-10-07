import 'package:flutter/material.dart';

import 'risk_score_screen.dart';
import 'vulnerability_analysis_screen.dart';
import 'relocation_sites_screen.dart';

class RiskDetailsScreen extends StatelessWidget {
  final String areaName;
  final int riskScore;
  final int population;
  final List<String> hazards;
  final String priority;

  const RiskDetailsScreen({
    super.key,
    required this.areaName,
    required this.riskScore,
    required this.population,
    required this.hazards,
    required this.priority,
  });

  Color get riskColor {
    if (riskScore >= 81) {
      return Colors.red;
    } else if (riskScore >= 61) {
      return Colors.orange;
    } else if (riskScore >= 31) {
      return Colors.amber.shade700;
    } else {
      return Colors.green;
    }
  }

  String get riskLevel {
    if (riskScore >= 81) {
      return 'CRITICAL';
    } else if (riskScore >= 61) {
      return 'HIGH';
    } else if (riskScore >= 31) {
      return 'MODERATE';
    } else {
      return 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Area name
          Text(
            areaName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Risk score card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Text(
                    'Risk Score',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '$riskScore / 100',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    riskLevel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Population
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.people,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Population',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '$population',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Detected hazards
          const Text(
            'Detected Hazards',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          ...hazards.map(
            (hazard) => Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                dense: true,
                leading: const Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                title: Text(hazard),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Relocation priority
          Card(
            color: Colors.red.shade50,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.priority_high,
                    color: Colors.red.shade700,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Relocation Priority',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(priority),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // -------------------------------------------------
          // RISK SCORE ANALYSIS BUTTON
          // -------------------------------------------------
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiskScoreScreen(
                      areaName: areaName,
                      riskScore: riskScore,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.analytics),
              label: const Text(
                'VIEW RISK SCORE ANALYSIS',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Vulnerability Analysis
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        VulnerabilityAnalysisScreen(
                      areaName: areaName,
                      population: population,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.groups),
              label: const Text(
                'VIEW VULNERABILITY ANALYSIS',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Relocation
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const RelocationSitesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.home_work),
              label: const Text(
                'FIND RELOCATION SITE',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}