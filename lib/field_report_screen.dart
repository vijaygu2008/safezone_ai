import 'package:flutter/material.dart';

class FieldReportScreen extends StatefulWidget {
  const FieldReportScreen({super.key});

  @override
  State<FieldReportScreen> createState() =>
      _FieldReportScreenState();
}

class _FieldReportScreenState
    extends State<FieldReportScreen> {
  final TextEditingController habitationController =
  TextEditingController();

  final TextEditingController populationController =
  TextEditingController();

  final TextEditingController roadController =
  TextEditingController();

  final TextEditingController waterController =
  TextEditingController();

  final TextEditingController commentsController =
  TextEditingController();

  String selectedHazard = 'Landslide';

  String selectedRoadCondition = 'Good';

  String selectedWaterAvailability = 'Available';

  @override
  void dispose() {
    habitationController.dispose();
    populationController.dispose();
    roadController.dispose();
    waterController.dispose();
    commentsController.dispose();

    super.dispose();
  }

  void submitReport() {
    if (habitationController.text.isEmpty ||
        populationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter habitation name and population.',
          ),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Field report submitted successfully.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Field Report',
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
            const Text(
              'Submit Field Report',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Enter ground-level information about the habitation',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            // LOCATION
            _sectionTitle(
              'Habitation Information',
            ),

            const SizedBox(height: 12),

            TextField(
              controller: habitationController,
              decoration: InputDecoration(
                labelText: 'Habitation Name',
                hintText: 'Enter habitation name',
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: populationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Population',
                hintText: 'Enter population',
                prefixIcon: const Icon(
                  Icons.people_outline,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // HAZARD
            _sectionTitle(
              'Hazard Information',
            ),

            const SizedBox(height: 12),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedHazard,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'Landslide',
                    child: Text('Landslide'),
                  ),
                  DropdownMenuItem(
                    value: 'Flood',
                    child: Text('Flood'),
                  ),
                  DropdownMenuItem(
                    value: 'Heavy Rainfall',
                    child: Text('Heavy Rainfall'),
                  ),
                  DropdownMenuItem(
                    value: 'Flash Flood',
                    child: Text('Flash Flood'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedHazard = value;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // ROAD CONDITION
            _sectionTitle(
              'Road Accessibility',
            ),

            const SizedBox(height: 12),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedRoadCondition,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'Good',
                    child: Text('Good'),
                  ),
                  DropdownMenuItem(
                    value: 'Moderate',
                    child: Text('Moderate'),
                  ),
                  DropdownMenuItem(
                    value: 'Poor',
                    child: Text('Poor'),
                  ),
                  DropdownMenuItem(
                    value: 'Blocked',
                    child: Text('Blocked'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedRoadCondition =
                          value;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // WATER
            _sectionTitle(
              'Water Availability',
            ),

            const SizedBox(height: 12),

            Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                ),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value:
                selectedWaterAvailability,
                isExpanded: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: 'Available',
                    child: Text('Available'),
                  ),
                  DropdownMenuItem(
                    value: 'Limited',
                    child: Text('Limited'),
                  ),
                  DropdownMenuItem(
                    value: 'Not Available',
                    child: Text(
                      'Not Available',
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedWaterAvailability =
                          value;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // ROAD OBSERVATION
            _sectionTitle(
              'Field Observations',
            ),

            const SizedBox(height: 12),

            TextField(
              controller: roadController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Road Condition Details',
                hintText:
                'Describe current road condition',
                prefixIcon: const Icon(
                  Icons.directions_car_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: waterController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Water Details',
                hintText:
                'Describe water availability',
                prefixIcon: const Icon(
                  Icons.water_drop_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: commentsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Additional Comments',
                hintText:
                'Enter additional observations',
                prefixIcon: const Icon(
                  Icons.notes_outlined,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // GPS BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'GPS location captured.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.my_location,
                ),
                label: const Text(
                  'Capture Current Location',
                ),
                style:
                OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // PHOTO BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Photo attachment feature selected.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.camera_alt_outlined,
                ),
                label: const Text(
                  'Attach Field Photo',
                ),
                style:
                OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // SUBMIT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: submitReport,
                icon: const Icon(
                  Icons.send,
                ),
                label: const Text(
                  'Submit Field Report',
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // DEMO NOTICE
            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'Field data entered here is currently '
                          'for demonstration. Later, this form '
                          'will send the report to the backend '
                          'and update the risk assessment.',
                      style: TextStyle(
                        fontSize: 13,
                      ),
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

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}