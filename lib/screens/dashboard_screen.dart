import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../gestational_calculator.dart';
import 'appointments_screen.dart';
import 'log_symptom_screen.dart';
import '../pdf_exporter.dart';
import '../emergency_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = "Loading...";                        //EDIT  new line of code database
  int _currentWeek = 1;
  String _currentTrimester = "First Trimester";
  bool _isLoading = true;
  List<Map<String, dynamic>> _weeklyArticles = [];
  Map<String, dynamic>? _upcomingAppointment;

  @override
  void initState() {
    super.initState();
    _fetchLocalUserData();
  }

  Future<void> _fetchLocalUserData() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> userRows = await db.query('users', limit: 1);
      
      if (userRows.isNotEmpty) {
        final user = userRows.first;
        final String name = user['name'];
        final DateTime lmp = DateTime.parse(user['lmp_date']);
        final int computedWeek = GestationalCalculator.calculateCurrentPregnancyWeek(lmp);
        
        String trimester = "First Trimester";
        if (computedWeek >= 13 && computedWeek <= 26) {
           trimester = "Second Trimester";
        }  else if (computedWeek >= 27) {
           trimester = "Third Trimester";
        }

        int lookupWeek = computedWeek;
        if (computedWeek >= 1 && computedWeek <= 4) {
          lookupWeek = 4; 
        } 

        List<Map<String, dynamic>> articleRows = await db.query(
          'educational_content',
          where: 'target_week = ?',
          whereArgs: [lookupWeek],
        );

        // If no article matches the exact week, show articles relevant to her current pregnancy stage
        if (articleRows.isEmpty) {
          articleRows = await db.query(
            'educational_content',
            where: 'target_week <= ?',
            whereArgs: [computedWeek],
            orderBy: 'target_week DESC',
            limit: 2,
          );
          if (articleRows.isEmpty) {
            articleRows = await db.query(
              'educational_content',
              orderBy: 'target_week ASC',
              limit: 2,
            );
          }
        }

        // Fetch upcoming uncompleted appointment
        final List<Map<String, dynamic>> apptRows = await db.query(
          'appointments',
          where: 'is_completed = 0',
          orderBy: 'scheduled_week ASC',
          limit: 1,
        );
        Map<String, dynamic>? nextAppt = apptRows.isNotEmpty ? apptRows.first : null;

        setState(() {
          _userName = name;
          _currentWeek = computedWeek;
          _currentTrimester = trimester;
          _weeklyArticles = articleRows;
          _upcomingAppointment = nextAppt;
          _isLoading = false;
        });
      } else {
        setState(() {
          _userName = "Mama";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }                                                        
 

  @override
  Widget build(BuildContext context) {
    double progressPercent = _currentWeek / 40.0; // 40 weeks total pregnancy duration

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('SafeMoms Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        elevation: 0,
        //drop a navigation shortcut button here                EDIT
        actions: [
  IconButton(
    icon: const Icon(Icons.calendar_month, color: Colors.white),
    tooltip: 'View WHO Schedule',
    onPressed: () {
      //standard flutter routing navigation tool to push the calender screen foward
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
      ).then((_) => _fetchLocalUserData());
    },
  ),   //EDIT end for appointment screen
      
         //                                                    EDIT
  IconButton(
    icon: const Icon(Icons.add_moderator, color: Colors.white),
    tooltip: 'Log Daily Vitals',
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogSymptomScreen()),
      );
    },
  ),
  IconButton(
    icon: const Icon(Icons.settings, color: Colors.white),
    tooltip: 'Settings',
    onPressed: () {
      _showSettingsDialog(context);
    },
  ),
],                                                          //EDIT end for LOG_symptom screen
      ),
      body:_isLoading
      ?const Center(child:CircularProgressIndicator())
       :SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Greeting Header Layout
              Text(
                "Hello, $_userName 👋",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text("You are currently in your $_currentTrimester.",style: const TextStyle(fontSize:14,color:Colors.grey )),
              // STEP 3.1: Insert the "Export PDF" Button widget right here!    EDIT start here
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.pinkAccent, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.pinkAccent),
                        label: const Text(
                          "Export Doctor Report (PDF)", 
                          style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 14)
                        ),
                        onPressed: () async {
                          // Displays a quick loading message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Compiling offline health records into PDF...')),
                          );
                          
                          // Calls Member 4's PDF compiler passing her dynamic profile name variable
                          await PdfExporter.generateAndShareReport(_userName);
                        },
                      ),
                    ),                //EDIT ending of pdf exporter 
              const SizedBox(height:24),
              //const Text(
                //"Welcome back to your data-free companion.",
                //style: TextStyle(fontSize: 14, color: Colors.grey),
              //),
              //const SizedBox(height: 24),

              // 2. Gestational Progress Indicator Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Pregnancy Progress",
                          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Week $_currentWeek / 40",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progressPercent.clamp(0.0, 1.0),
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${(progressPercent.clamp(0.0, 1.0) * 100).toInt()}% completed. You are doing amazing!",
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 2.5 WHO Schedule Reminder View
              if (_upcomingAppointment != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.pinkAccent,
                        child: Icon(Icons.calendar_month, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Next WHO Checkup",
                              style: TextStyle(fontSize: 12, color: Colors.pinkAccent, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _upcomingAppointment!['title'],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Target Date: ${_upcomingAppointment!['target_date']} (Week ${_upcomingAppointment!['scheduled_week']})",
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
                          ).then((_) => _fetchLocalUserData());
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
              ],

              // 3. Filtered Education List View Container
              Text(
                "Your Week $_currentWeek Health Insights",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              
              _weeklyArticles.isEmpty
               ?Container(width:double.infinity, padding: const EdgeInsets.all(20),decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),child: const Text("Rest well today! Complete your symptom logs for your next clinical doctor visit",style: TextStyle(fontSize: 14,color: Colors.grey,height:1.4)))
              :ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Stops inner scrolling conflicts
                itemCount: _weeklyArticles.length,
                itemBuilder: (context, index) {
                  final article = _weeklyArticles[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bookmark_added, color: Colors.pinkAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              article["title"]!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article["body_text"]!,
                          style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 100), // Extra padding to allow scrolling past the steady SOS button
            ],
          ),
        ),
      ),

      // 4. Critical Accessibility: The Big Red Floating SOS Button
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: Colors.red,
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SOS Emergency Mode Activated! Capturing device GPS and broadcasting rescue text message...'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );

          bool sent = await EmergencyController.triggerEmergencyProtocol();
          if (!context.mounted) return;
          if (!sent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not send SOS: please ensure emergency contact is saved in profile.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        //backgroundColor: Colors.red,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gpp_maybe, color: Colors.white, size: 36),
            Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) async {
    final TextEditingController phoneController = TextEditingController();
    
    // Fetch current phone number
    final userProfile = await DatabaseHelper.instance.getUserProfile();
    if (userProfile != null) {
      phoneController.text = userProfile['phone']?.toString() ?? '';
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Update Emergency Contact Number', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'e.g., +237677XXXXXX',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone, color: Colors.pinkAccent),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPhone = phoneController.text.trim();
                if (newPhone.isNotEmpty) {
                  await DatabaseHelper.instance.updateEmergencyContact(newPhone);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Emergency contact updated!'), backgroundColor: Colors.green),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid number'), backgroundColor: Colors.red),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
