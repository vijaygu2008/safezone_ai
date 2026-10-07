import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        'title': 'Critical Zone Alert',
        'area': 'Critical Zone',
        'risk': 92,
        'type': 'Flood + Landslide',
        'action': 'Immediate Relocation',
        'time': '10 minutes ago',
        'color': Colors.red,
        'icon': Icons.warning,
      },
      {
        'title': 'High Risk Area',
        'area': 'High Risk Area',
        'risk': 84,
        'type': 'Heavy Rainfall + Landslide',
        'action': 'Prepare for Relocation',
        'time': '35 minutes ago',
        'color': Colors.orange,
        'icon': Icons.warning_amber,
      },
      {
        'title': 'Rainfall Warning',
        'area': 'Mountain Village',
        'risk': 76,
        'type': 'Heavy Rainfall',
        'action': 'Monitor Situation',
        'time': '1 hour ago',
        'color': Colors.orange,
        'icon': Icons.cloud,
      },
      {
        'title': 'Preparedness Alert',
        'area': 'River Side Habitation',
        'risk': 68,
        'type': 'Flood Exposure',
        'action': 'Maintain Preparedness',
        'time': '2 hours ago',
        'color': Colors.blue,
        'icon': Icons.info,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alerts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // HEADER
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: Colors.red,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Active Alerts',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Latest hazard and relocation warnings',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ALERT SUMMARY
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'Critical',
                  '1',
                  Colors.red,
                  Icons.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryCard(
                  'High',
                  '2',
                  Colors.orange,
                  Icons.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryCard(
                  'Moderate',
                  '1',
                  Colors.blue,
                  Icons.info,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'Recent Alerts',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // ALERT LIST
          ...alerts.map(
                (alert) => _alertCard(context, alert),
          ),

          const SizedBox(height: 20),

          // SYSTEM STATUS
          Card(
            color: Colors.green.shade50,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alert Monitoring Active',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'SafeZone AI is continuously monitoring risk conditions.',
                          style: TextStyle(
                            fontSize: 13,
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

  static Widget _summaryCard(
      String title,
      String count,
      Color color,
      IconData icon,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 25,
            ),
            const SizedBox(height: 6),
            Text(
              count,
              style: TextStyle(
                color: color,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _alertCard(
      BuildContext context,
      Map<String, dynamic> alert,
      ) {
    final Color color = alert['color'];

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alert['icon'],
                    color: color,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    alert['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${alert['risk']}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            _detailRow(
              Icons.location_on,
              'Area',
              alert['area'],
            ),

            _detailRow(
              Icons.warning_amber,
              'Hazard',
              alert['type'],
            ),

            _detailRow(
              Icons.directions_run,
              'Recommended Action',
              alert['action'],
            ),

            _detailRow(
              Icons.access_time,
              'Updated',
              alert['time'],
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showAlertDetails(context, alert);
                },
                icon: const Icon(Icons.visibility),
                label: const Text('VIEW ALERT DETAILS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _detailRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.grey.shade700,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showAlertDetails(
      BuildContext context,
      Map<String, dynamic> alert,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                alert['icon'],
                color: alert['color'],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  alert['title'],
                ),
              ),
            ],
          ),
          content: Text(
            'Area: ${alert['area']}\n\n'
                'Risk Score: ${alert['risk']}/100\n\n'
                'Hazard: ${alert['type']}\n\n'
                'Recommended Action: ${alert['action']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }
}