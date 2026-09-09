class GestationalCalculator {
  
  // STEP 2.1: Implement Naegele's Rule Algorithm
  // Formula: Estimated Date of Delivery (EDD) = Last Period Date (LMP) + 7 Days + 1 Year - 3 Months
  static DateTime calculateEDD(DateTime lmp) {
    return lmp.add(const Duration(days: 7))    // Add 7 days to baseline date
              .add(const Duration(days: 365))   // Add 1 full calendar year
              .subtract(const Duration(days: 90)); // Subtract 3 calendar months
  }

  // STEP 2.2: Compute Current Gestational Week Interval
  // Calculates how many weeks have passed between the mother's last period and today's calendar date
  static int calculateCurrentPregnancyWeek(DateTime lmp) {
    final DateTime today = DateTime.now();
    final int differenceInDays = today.difference(lmp).inDays;
    
    // Divide active day count by 7 and round up to yield current week index
    int week = (differenceInDays / 7).ceil();
    
    // Bounds check safety limit markers (Standard human gestation frames)
    if (week < 1) week = 1;
    if (week > 40) week = 40;
    return week;
  }

  // STEP 2.3: Automate the 8 WHO Antenatal Care Milestone Timelines
  // Takes the base period date and calculates the exact calendar day for the mandatory checkups
  static List<Map<String, dynamic>> generateWHOSchedule(DateTime lmp) {
    // Definitive reference database map for standard WHO health screening weeks
    final List<Map<String, dynamic>> whoMilestones = [
      {'week': 12, 'title': '1st Contact: Early Scan & Booking'},
      {'week': 20, 'title': '2nd Contact: Anomaly Assessment'},
      {'week': 26, 'title': '3rd Contact: Gestational Screening'},
      {'week': 30, 'title': '4th Contact: Tetanus & Vitals Check'},
      {'week': 34, 'title': '5th Contact: Fetal Growth Monitoring'},
      {'week': 36, 'title': '6th Contact: Presentation Evaluation'},
      {'week': 38, 'title': '7th Contact: Delivery Readiness Plan'},
      {'week': 40, 'title': '8th Contact: Final Term Assessment'},
    ];

    List<Map<String, dynamic>> generatedTimelineArray = [];

    for (var milestone in whoMilestones) {
      int targetWeek = milestone['week'];
      
      // Convert week milestone intervals into physical day limits (e.g., Week 12 = 84 Days)
      int targetDays = targetWeek * 7;
      
      // Perform automated date arithmetic properties on device clock threads
      DateTime scheduledDate = lmp.add(Duration(days: targetDays));
      
      // Format the raw timestamp token into a clean string (YYYY-MM-DD)
      String formattedCalendarDate = "${scheduledDate.year}-${scheduledDate.month.toString().padLeft(2, '0')}-${scheduledDate.day.toString().padLeft(2, '0')}";

      generatedTimelineArray.add({
        'title': milestone['title'],
        'scheduled_week': targetWeek,
        'target_date': formattedCalendarDate,
        'is_completed': 0, // 0 translates to incomplete/pending checkup event
      });
    }

    return generatedTimelineArray;
  }
}
