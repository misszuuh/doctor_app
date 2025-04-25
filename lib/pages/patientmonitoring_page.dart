import 'package:flutter/material.dart';
// Add this import
import 'package:intl/intl.dart';

class PatientMonitoringPage extends StatefulWidget {
  const PatientMonitoringPage({super.key});

  @override
  State<PatientMonitoringPage> createState() => _PatientMonitoringPageState();
}

class _PatientMonitoringPageState extends State<PatientMonitoringPage> {
  final List<Patient> _patients = [
    Patient(
      id: '1',
      name: 'John Doe',
      status: 'High Risk',
      lastBp: '142/88',
      lastHeartRate: '92',
      lastGlucose: '110',
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Patient(
      id: '2',
      name: 'Mary Smith',
      status: 'Stable',
      lastBp: '118/76',
      lastHeartRate: '72',
      lastGlucose: '95',
      lastUpdate: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredPatients = _patients.where((patient) {
      final matchesSearch = patient.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == 'All' || patient.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search patients...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'High Risk', child: Text('High Risk')),
                    DropdownMenuItem(value: 'Stable', child: Text('Stable')),
                  ],
                  onChanged: (value) => setState(() => _selectedFilter = value!),
                ),
              ],
            ),
          ),

          // Patient List
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                final patient = filteredPatients[index];
                return _buildPatientCard(patient);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: patient.status == 'High Risk' 
              ? Colors.red.withAlpha(50) // Fixed deprecated withOpacity
              : Colors.green.withAlpha(50),
          child: Text(patient.name[0]),
        ),
        title: Text(patient.name),
        subtitle: Text('Status: ${patient.status}'),
        trailing: Text(
          DateFormat('h:mm a').format(patient.lastUpdate),
          style: const TextStyle(color: Colors.grey),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Vital Signs Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildVitalIndicator('BP', patient.lastBp, 
                        patient.lastBp.split('/')[0].compareTo('140') > 0 ? Colors.red : Colors.green),
                    _buildVitalIndicator('Heart Rate', patient.lastHeartRate, 
                        int.parse(patient.lastHeartRate) > 100 ? Colors.red : Colors.green),
                    _buildVitalIndicator('Glucose', patient.lastGlucose, 
                        int.parse(patient.lastGlucose) > 140 ? Colors.red : Colors.green),
                  ],
                ),
                const SizedBox(height: 20),

                // Simplified Chart (remove if not using fl_chart)
                Container(
                  height: 200,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Text('Chart Placeholder', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _viewPatientDetails(patient),
                  child: const Text('View Full History'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          )),
        ),
      ],
    );
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing data...')),
    );
  }

  void _viewPatientDetails(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsPage(patient: patient),
      ),
    );
  }
}

class Patient {
  final String id;
  final String name;
  final String status;
  final String lastBp;
  final String lastHeartRate;
  final String lastGlucose;
  final DateTime lastUpdate;

  Patient({
    required this.id,
    required this.name,
    required this.status,
    required this.lastBp,
    required this.lastHeartRate,
    required this.lastGlucose,
    required this.lastUpdate,
  });
}

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(patient.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Detailed view for ${patient.name}'),
          ],
        ),
      ),
    );
  }
}