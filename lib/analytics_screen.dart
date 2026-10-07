import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Risk Analytics Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Overview of hazard exposure, vulnerable population and risk distribution.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // KEY STATISTICS
          Row(
            children: [
              Expanded(
                child: _statCard(
                  '152',
                  'Total Areas',
                  Icons.location_city,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  '40',
                  'High Risk',
                  Icons.warning,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _statCard(
                  '1,240',
                  'Population at Risk',
                  Icons.people,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  '12',
                  'Critical Zones',
                  Icons.dangerous,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // RISK DISTRIBUTION
          const Text(
            'Risk Distribution',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _riskBar(
                    'Critical',
                    12,
                    152,
                    Colors.red,
                  ),
                  const SizedBox(height: 15),
                  _riskBar(
                    'High',
                    28,
                    152,
                    Colors.orange,
                  ),
                  const SizedBox(height: 15),
                  _riskBar(
                    'Moderate',
                    45,
                    152,
                    Colors.amber,
                  ),
                  const SizedBox(height: 15),
                  _riskBar(
                    'Low',
                    67,
                    152,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // HAZARD ANALYSIS
          const Text(
            'Hazard Analysis',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _hazardCard(
            Icons.water,
            'Flood',
            'High exposure',
            72,
            Colors.blue,
          ),

          _hazardCard(
            Icons.landscape,
            'Landslide',
            'High exposure',
            64,
            Colors.brown,
          ),

          _hazardCard(
            Icons.cloud,
            'Heavy Rainfall',
            'Moderate exposure',
            58,
            Colors.indigo,
          ),

          const SizedBox(height: 15),

          // VULNERABILITY
          const Text(
            'Vulnerability Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _vulnerabilityRow(
                    'Children',
                    '280',
                    Icons.child_care,
                  ),
                  _vulnerabilityRow(
                    'Elderly',
                    '190',
                    Icons.elderly,
                  ),
                  _vulnerabilityRow(
                    'Persons with Disabilities',
                    '75',
                    Icons.accessible,
                  ),
                  _vulnerabilityRow(
                    'Total Vulnerable Population',
                    '545',
                    Icons.groups,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // RELOCATION SUMMARY
          const Text(
            'Relocation Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Card(
            color: Colors.green.shade50,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Icon(
                    Icons.home_work,
                    color: Colors.green,
                    size: 42,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    '3 Candidate Relocation Sites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Candidate sites are evaluated using safety, capacity, road access, healthcare access and hazard exposure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          // SYSTEM STATUS
          Card(
            color: Colors.blue.shade50,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: Colors.blue,
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analytics Status',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Risk and vulnerability indicators are available for decision support.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  static Widget _statCard(
      String value,
      String title,
      IconData icon,
      Color color,
      ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _riskBar(
      String title,
      int value,
      int total,
      Color color,
      ) {
    final double percentage = value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$value areas',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 7),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 10,
            color: color,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  static Widget _hazardCard(
      IconData icon,
      String title,
      String subtitle,
      int score,
      Color color,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          '$score%',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  static Widget _vulnerabilityRow(
      String title,
      String value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}