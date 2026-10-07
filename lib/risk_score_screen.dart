import 'package:flutter/material.dart';

import 'api_service.dart';

class RiskScoreScreen extends StatefulWidget {
  final String areaName;
  final int riskScore;

  const RiskScoreScreen({
    super.key,
    required this.areaName,
    required this.riskScore,
  });

  @override
  State<RiskScoreScreen> createState() => _RiskScoreScreenState();
}

class _RiskScoreScreenState extends State<RiskScoreScreen> {
  bool isLoading = true;
  bool isMLLoading = true;

  String? errorMessage;
  String? mlErrorMessage;

  Map<String, dynamic>? riskData;
  Map<String, dynamic>? mlData;

  @override
  void initState() {
    super.initState();
    _loadRiskData();
  }

  Future<void> _loadRiskData() async {
    setState(() {
      isLoading = true;
      isMLLoading = true;
      errorMessage = null;
      mlErrorMessage = null;
    });

    try {
      final data = await ApiService.getRiskScore();

      if (!mounted) {
        return;
      }

      setState(() {
        riskData = data;
        isLoading = false;
      });

      await _runMLPrediction();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
        isMLLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _runMLPrediction() async {
    setState(() {
      isMLLoading = true;
      mlErrorMessage = null;
    });

    try {
      /*
       * -------------------------------------------------------
       * Prototype demonstration feature values
       * -------------------------------------------------------
       *
       * These values correspond to the demonstration dataset
       * used to train the current Random Forest model.
       *
       * In the production version, these values will come from
       * actual GIS, historical disaster and population data.
       */

      final result = await ApiService.predictMLRisk(
        floodExposure: 95,
        landslideExposure: 90,
        rainfall: 92,
        slope: 85,
        elevation: 35,
        populationDensity: 88,
        vulnerablePopulation: 90,
        disasterHistory: 95,
        distanceFromRiver: 8,
        roadAccess: 20,
        healthcareAccess: 25,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        mlData = result;
        isMLLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isMLLoading = false;
        mlErrorMessage = e.toString();
      });
    }
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'moderate':
        return Colors.amber.shade700;
      case 'low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatFeatureName(String name) {
    return name
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk Score Analysis'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadRiskData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load risk data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadRiskData,
              icon: const Icon(Icons.refresh),
              label: const Text('TRY AGAIN'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final data = riskData ?? {};

    final overallScore =
        (data['overall_score'] ?? widget.riskScore) as num;

    final riskLevel =
        (data['risk_level'] ?? 'Unknown').toString();

    final components =
        data['components'] as Map<String, dynamic>? ?? {};

    final weights =
        data['weights'] as Map<String, dynamic>? ?? {};

    final explanations =
        data['explanation'] as List<dynamic>? ?? [];

    return RefreshIndicator(
      onRefresh: _loadRiskData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAreaHeader(),
          const SizedBox(height: 16),
          _buildOverallRiskCard(
            overallScore: overallScore,
            riskLevel: riskLevel,
          ),
          const SizedBox(height: 16),
          _buildMLPredictionCard(),
          const SizedBox(height: 16),
          _buildComponentsCard(
            components: components,
            weights: weights,
          ),
          const SizedBox(height: 16),
          _buildExplanationCard(explanations),
          const SizedBox(height: 16),
          _buildPrototypeNote(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAreaHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Area Under Analysis',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.areaName,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallRiskCard({
    required num overallScore,
    required String riskLevel,
  }) {
    final color = _riskColor(riskLevel);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'EXPLAINABLE RISK SCORE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.12),
                border: Border.all(
                  color: color,
                  width: 6,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      overallScore.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const Text(
                      '/ 100',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                riskLevel.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMLPredictionCard() {
    if (isMLLoading) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.psychology,
                size: 42,
                color: Colors.deepPurple,
              ),
              SizedBox(height: 12),
              Text(
                'Running Random Forest Model...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    if (mlErrorMessage != null || mlData == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_off,
                size: 42,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              const Text(
                'ML Prediction Unavailable',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mlErrorMessage ?? 'Unable to connect to ML service.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _runMLPrediction,
                icon: const Icon(Icons.refresh),
                label: const Text('RUN AGAIN'),
              ),
            ],
          ),
        ),
      );
    }

    final prediction =
        mlData!['prediction'] ?? 0;

    final riskLevel =
        (mlData!['risk_level'] ?? 'Unknown').toString();

    final confidence =
        (mlData!['confidence'] ?? 0) as num;

    final modelName =
        (mlData!['model'] ?? 'Random Forest').toString();

    final color = _riskColor(riskLevel);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.deepPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MACHINE LEARNING PREDICTION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Random Forest Model',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _runMLPrediction,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Run prediction again',
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'PREDICTED RISK LEVEL',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    riskLevel,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Prediction Class: $prediction',
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _buildMLStat(
                    title: 'Confidence',
                    value: '${confidence.toStringAsFixed(1)}%',
                    icon: Icons.verified,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMLStat(
                    title: 'Model',
                    value: modelName,
                    icon: Icons.auto_awesome,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMLStat({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsCard({
    required Map<String, dynamic> components,
    required Map<String, dynamic> weights,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  'Risk Components',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (components.isEmpty)
              const Text(
                'No component data available.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            else
              ...components.entries.map(
                (entry) {
                  final component =
                      entry.value as Map<String, dynamic>? ?? {};

                  final score =
                      (component['score'] ?? 0) as num;

                  final maximum =
                      (component['maximum'] ?? 100) as num;

                  final percentage =
                      (component['percentage'] ?? 0) as num;

                  final weight =
                      weights[entry.key] ?? 0;

                  final progress = maximum > 0
                      ? (score / maximum).clamp(0.0, 1.0)
                      : 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 18,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _formatFeatureName(entry.key),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${score.toStringAsFixed(0)}/${maximum.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Weight: $weight%',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(List<dynamic> explanations) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  'Why is the risk high?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (explanations.isEmpty)
              const Text(
                'No explanation available.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            else
              ...explanations.asMap().entries.map(
                (entry) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(
                              alpha: 0.12,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrototypeNote() {
    return Card(
      color: Colors.blue.shade50,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.blue.shade100,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue.shade700,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Prototype note: The current Random Forest prediction '
                'uses demonstration training data. For production '
                'deployment, the model will be trained and validated '
                'using authoritative historical disaster, GIS, '
                'population and infrastructure data.',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}