import 'package:flutter/material.dart';
import '../database_helper.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  // Task: Fetch generated timeline rows straight out of the local SQLite database
  Future<void> _loadAppointments() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('appointments');
    
    setState(() {
      _appointments = maps;
      _isLoading = false;
    });
  }

  // Task: Toggle completion check flag directly inside the SQLite database row
  Future<void> _toggleAppointmentStatus(int id, int currentStatus) async {
    final db = await DatabaseHelper.instance.database;
    int newStatus = currentStatus == 1 ? 0 : 1;
    
    await db.update(
      'appointments',
      {'is_completed': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    
    // Reload UI state immediately to refresh checkmarks on screen
    _loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('My WHO Schedule', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? const Center(
                  child: Text(
                    'No checkups generated.\nPlease complete onboarding setup first.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final appt = _appointments[index];
                    bool isDone = appt['is_completed'] == 1;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      color: isDone ? Colors.green.withValues(alpha: 0.05) : Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isDone ? Colors.green : Colors.pinkAccent.withValues(alpha: 0.1),
                          child: Icon(
                            isDone ? Icons.check : Icons.calendar_today,
                            color: isDone ? Colors.white : Colors.pinkAccent,
                          ),
                        ),
                        title: Text(
                          appt['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            "Target Date: ${appt['target_date']} (Week ${appt['scheduled_week']})",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        trailing: Checkbox(
                          activeColor: Colors.green,
                          value: isDone,
                          onChanged: (bool? newValue) {
                            _toggleAppointmentStatus(appt['id'], appt['is_completed']);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
