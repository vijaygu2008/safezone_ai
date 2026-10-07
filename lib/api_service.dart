import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Android Emulator -> host computer
  static const String baseUrl = 'http://10.0.2.2:8000';

  // =========================================================
  // Basic Risk
  // =========================================================

  static Future<Map<String, dynamic>> getRisk() async {
    final response = await http.get(
      Uri.parse('$baseUrl/risk'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load risk data');
  }

  // =========================================================
  // Risk Map
  // =========================================================

  static Future<List<dynamic>> getRiskMap() async {
    final response = await http.get(
      Uri.parse('$baseUrl/risk-map'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['locations'] as List<dynamic>;
    }

    throw Exception('Failed to load risk map data');
  }

  // =========================================================
  // Relocation Sites
  // =========================================================

  static Future<List<dynamic>> getRelocationSites() async {
    final response = await http.get(
      Uri.parse('$baseUrl/relocation-sites'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['sites'] as List<dynamic>;
    }

    throw Exception('Failed to load relocation sites');
  }

  // =========================================================
  // Priority Ranking
  // =========================================================

  static Future<List<dynamic>> getPriorityRanking() async {
    final response = await http.get(
      Uri.parse('$baseUrl/priority-ranking'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['areas'] as List<dynamic>;
    }

    throw Exception('Failed to load priority ranking');
  }

  // =========================================================
  // Explainable Risk Score
  // =========================================================

  static Future<Map<String, dynamic>> getRiskScore() async {
    final response = await http.get(
      Uri.parse('$baseUrl/risk-score'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load risk score');
  }

  // =========================================================
  // ML Risk Prediction
  // =========================================================

  static Future<Map<String, dynamic>> predictMLRisk({
    required double floodExposure,
    required double landslideExposure,
    required double rainfall,
    required double slope,
    required double elevation,
    required double populationDensity,
    required double vulnerablePopulation,
    required double disasterHistory,
    required double distanceFromRiver,
    required double roadAccess,
    required double healthcareAccess,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/ml-risk'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'flood_exposure': floodExposure,
        'landslide_exposure': landslideExposure,
        'rainfall': rainfall,
        'slope': slope,
        'elevation': elevation,
        'population_density': populationDensity,
        'vulnerable_population': vulnerablePopulation,
        'disaster_history': disasterHistory,
        'distance_from_river': distanceFromRiver,
        'road_access': roadAccess,
        'healthcare_access': healthcareAccess,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception(
      'ML risk prediction failed: ${response.statusCode}',
    );
  }

  // =========================================================
  // Alerts
  // =========================================================

  static Future<List<dynamic>> getAlerts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/alerts'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['alerts'] as List<dynamic>;
    }

    throw Exception('Failed to load alerts');
  }

  // =========================================================
  // Analytics
  // =========================================================

  static Future<Map<String, dynamic>> getAnalytics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/analytics'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load analytics');
  }

  // =========================================================
  // Vulnerability
  // =========================================================

  static Future<Map<String, dynamic>> getVulnerability() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vulnerability'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load vulnerability data');
  }

  // =========================================================
  // Health Check
  // =========================================================

  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // =========================================================
  // System Information
  // =========================================================

  static Future<Map<String, dynamic>> getSystemInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/system-info'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw Exception('Failed to load system information');
  }
}