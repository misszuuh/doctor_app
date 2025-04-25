import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'alerts_page';
import 'chatbot_page';
import 'patientmonitoring_page.dart';
import 'prescription_page';

class DoctorHomePage extends StatefulWidget {
  final String username;
  
  const DoctorHomePage({super.key, required this.username});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  // Sample data - replace with your actual data source
  final List<PatientAlert> _alerts = [
    PatientAlert(
      patientName: "John Doe",
      vital: "Blood Pressure",
      value: "150/95",
      status: "Critical",
      time: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    PatientAlert(
      patientName: "Mary Smith",
      vital: "Heart Rate",
      value: "110 bpm",
      status: "High",
      time: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  final int _assignedPatients = 12;
  final int _criticalAlerts = 3;
  final int _unreadMessages = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. ${widget.username}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showAllAlerts,
            tooltip: "View All Alerts",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActionsSection(),
            const SizedBox(height: 24),
            
            // Recent Alerts Header
            _buildAlertsHeader(),
            
            // Alerts List
            Expanded(
              child: _buildAlertsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _buildSummaryCard(
          icon: Icons.group,
          value: _assignedPatients,
          label: "Patients",
          color: Colors.blue,
        ),
        const SizedBox(width: 12),
        _buildSummaryCard(
          icon: Icons.warning_amber,
          value: _criticalAlerts,
          label: "Critical Alerts",
          color: Colors.red,
        ),
        const SizedBox(width: 12),
        _buildSummaryCard(
          icon: Icons.message,
          value: _unreadMessages,
          label: "Messages",
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: color),
              const SizedBox(height: 8),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildActionButton(
              icon: Icons.monitor_heart,
              label: "Patient Monitoring",
              onPressed: _navigateToPatientMonitoring,
            ),
            _buildActionButton(
              icon: Icons.chat,
              label: "Chat",
              onPressed: _navigateToChat,
            ),
            _buildActionButton(
              icon: Icons.medical_services,
              label: "Prescribe",
              onPressed: _navigateToPrescription,
            ),
             _buildActionButton(
            icon: Icons.notifications_active,
            label: "Alerts",
            onPressed: _navigateToAlertsPage,
          ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildAlertsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Alerts",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          child: const Text("See All"),
          onPressed: _showAllAlerts,
        ),
      ],
    );
  }

  Widget _buildAlertsList() {
    return ListView.builder(
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(PatientAlert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: alert.status == "Critical" ? Colors.red[50] : null,
      child: ListTile(
        leading: Icon(
          Icons.warning,
          color: alert.status == "Critical" ? Colors.red : Colors.orange,
        ),
        title: Text(alert.patientName),
        subtitle: Text("${alert.vital}: ${alert.value}"),
        trailing: Text(
          DateFormat('h:mm a').format(alert.time),
          style: const TextStyle(color: Colors.grey),
        ),
        onTap: () => _showAlertDetails(alert),
      ),
    );
  }

  // Navigation Methods
  void _navigateToPatientMonitoring() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientMonitoringPage(),
      ),
    );
  }

  void _navigateToChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatbotPage(),
        )
        );
  }

  void _navigateToPrescription() {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  PrescriptionPage(
          patientId: 'PAT123',
          patientName: 'John Doe',
          ),
        ),
     );
  }

void _navigateToAlertsPage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AlertsPage(),
    ),
  );
}


  void _showAllAlerts() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _alerts.length,
          itemBuilder: (context, index) {
            return _buildAlertCard(_alerts[index]);
          },
        );
      },
    );
  }

  void _showAlertDetails(PatientAlert alert) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alert Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Patient: ${alert.patientName}"),
              Text("Vital: ${alert.vital}"),
              Text("Value: ${alert.value}"),
              Text("Status: ${alert.status}"),
              Text("Time: ${DateFormat('MMM d, h:mm a').format(alert.time)}"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Dismiss"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Send Advice"),
              onPressed: () {
                Navigator.pop(context);
                _navigateToChat();
              },
            ),
          ],
        );
      },
    );
  }
}

class PatientAlert {
  final String patientName;
  final String vital;
  final String value;
  final String status;
  final DateTime time;

  PatientAlert({
    required this.patientName,
    required this.vital,
    required this.value,
    required this.status,
    required this.time,
  });
}