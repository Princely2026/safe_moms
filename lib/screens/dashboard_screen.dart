import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Hardcoded profile data (We will connect this to your SQLite tables in Phase 2)
  final String userName = "Mama Marie";
  final int currentWeek = 14; 

  // Local archive of educational content matching Gestational Week 14
  final List<Map<String, String>> weeklyInsights = [
    {
      "title": "Baby's Development",
      "body": "Your baby is now the size of a lemon! Facial muscles are starting to form, allowing them to squint and grimace inside the womb."
    },
    {
      "title": "Nutrition Tips",
      "body": "Your blood volume is expanding rapidly during this second trimester. Focus heavily on iron-rich local foods like spinach and beans to prevent anemia."
    }
  ];

  @override
  Widget build(BuildContext context) {
    double progressPercent = currentWeek / 40.0; // 40 weeks total pregnancy duration

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('SafeMoms Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Greeting Header Layout
              Text(
                "Hello, $userName 👋",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                "Welcome back to your data-free companion.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

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
                          "Pregnancy Timeline",
                          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "Week $currentWeek / 40",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${(progressPercent * 100).toInt()}% completed. You are doing amazing!",
                      style: const TextStyle(color: Colors.white, fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 3. Filtered Education List View Container
              Text(
                "Your Week $currentWeek Health Insights",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Stops inner scrolling conflicts
                itemCount: weeklyInsights.length,
                itemBuilder: (context, index) {
                  final item = weeklyInsights[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.bookmark_added, color: Colors.pinkAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              item["title"]!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["body"]!,
                          style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // 4. Critical Accessibility: The Big Red Floating SOS Button
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          print("SOS Broadcast Triggered!");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('SOS Emergency Mode Activated! Assessing risks offline...'),
              backgroundColor: Colors.red,
            ),
          );
        },
        backgroundColor: Colors.red,
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
}
