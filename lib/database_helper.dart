import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  // Singleton pattern: Protects memory by keeping a single shared data stream channel active
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('SafeMoms.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }


  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // 1. User Profile Setup Table
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        phone $textType,
        lmp_date $textType,
        edd_date $textType
      )
    ''');

    // 2. WHO Antenatal Care Checkups Schedule Table
    await db.execute('''
      CREATE TABLE appointments (
        id $idType,
        title $textType,
        scheduled_week $intType,
        target_date $textType,
        is_completed $intType DEFAULT 0
      )
    ''');

    // 3. Static Offline Pregnancy Insights Articles Table
    await db.execute('''
      CREATE TABLE educational_content (
        id $idType,
        target_week $intType,
        title $textType,
        body_text $textType
      )
    ''');

    // 4. Emergency Hardware Contacts Table
    await db.execute('''
      CREATE TABLE emergency_contacts (
        id $idType,
        contact_name $textType,
        phone_number $textType
      )
    ''');

    // 5. MERGED: Daily Symptom Log Tracking Table for PDF Doctor Reports
    await db.execute('''
      CREATE TABLE symptoms (
        id $idType,
        logged_date $textType,
        weight $textType,
        systolic_bp $textType,
        diastolic_bp $textType,
        symptom_notes $textType
      )
    ''');

    // Automatically seed internal educational libraries on database initialization
    await _seedDatabase(db);
  }

   Future<void> _seedDatabase(Database db) async {
    // Comprehensive Cameroon-specific week-by-week maternal health education data matrix
    final List<Map<String, dynamic>> localizedGuide = [
      // Trimester 1 (Weeks 1 to 12)
      {
        'target_week': 4,
        'title': 'Trimester 1: Implantation',
        'body_text': 'Baby: Implantation occurs. Development is early.\nNutrition: Balanced meals; folate-rich dark greens, beans.\nSymptoms: Tiredness, breast tenderness or mild nausea.\nAdvice: Confirm pregnancy and start ANC early. Avoid alcohol/tobacco.'
      },
      {
        'target_week': 5,
        'title': 'Trimester 1: Embryo Growth',
        'body_text': 'Baby: Embryo develops rapidly; brain/spinal structures form.\nNutrition: Beans, groundnuts, nuts, eggs, safe water.\nSymptoms: Nausea, vomiting, fatigue and frequent urination.\nAdvice: Small frequent meals help nausea. Keep first ANC appointment early.'
      },
      {
        'target_week': 6,
        'title': 'Trimester 1: Early Heart Development',
        'body_text': 'Baby: Heart development begins; nervous system continues growing.\nNutrition: Varied protein, vegetables, local grains, tubers.\nSymptoms: Nausea, food aversions, fatigue, breast changes.\nAdvice: Rest when needed. Take prescribed iron/folic acid supplements exactly.'
      },
      {
        'target_week': 7,
        'title': 'Trimester 1: Organ Formation',
        'body_text': 'Baby: Brain and internal organs continue forming.\nNutrition: Iron-rich foods; pair plant iron with vitamin C fruits.\nSymptoms: Nausea, vomiting, constipation, extreme fatigue.\nAdvice: Safe food/water habits. Discuss persistent vomiting with an ANC midwife.'
      },
      {
        'target_week': 8,
        'title': 'Trimester 1: Body Structure Definition',
        'body_text': 'Baby: Limbs and facial features become more defined.\nNutrition: Include local staples, fresh vegetables, protein sources.\nSymptoms: Bloating, constipation, nausea, breast tenderness.\nAdvice: Avoid self-medicating. Attend your structured clinic appointments.'
      },
      {
        'target_week': 9,
        'title': 'Trimester 1: Fetal Phase Transition',
        'body_text': 'Baby: Moving toward fetal stage; organs continue maturing.\nNutrition: Maintain balanced diet; do not rely on a single food group.\nSymptoms: Nausea and fatigue persist; emotional mood changes occur.\nAdvice: Ask your clinic about malaria prevention and local bed net protocols.'
      },
      {
        'target_week': 10,
        'title': 'Trimester 1: Basic Forms Set',
        'body_text': 'Baby: Organs formed in basic form; fingers and toes develop.\nNutrition: Iron-rich items plus prescribed iron/folic supplements; high fluids.\nSymptoms: Constipation, heartburn, persistent nausea and fatigue.\nAdvice: Gentle activity if appropriate. Report concerning symptoms immediately.'
      },
      {
        'target_week': 11,
        'title': 'Trimester 1: Rapid Fetal Growth',
        'body_text': 'Baby: Fetus continues rapid growth; bones/facial structures develop.\nNutrition: Vegetables, fruit, legumes, healthy energy sources.\nSymptoms: Nausea may improve; constipation and heartburn can occur.\nAdvice: Continue standard ANC, prescribed supplements, and preventive care.'
      },
      {
        'target_week': 12,
        'title': 'Trimester 1: First Milestone established',
        'body_text': 'Baby: Rapid growth; major structures established.\nNutrition: Variety and adequate fluids; continue prescribed supplements.\nSymptoms: Nausea improves; mild abdominal stretching sensations.\nAdvice: Early ANC assessment is critical. Review dating and screening results.'
      },

      // Trimester 2 (Weeks 13 to 26)
      {
        'target_week': 13,
        'title': 'Trimester 2: Trimester Transition',
        'body_text': 'Baby: Second trimester begins; movement coordinates.\nNutrition: Balanced meals; include calcium sources (milk/local alternatives).\nSymptoms: Energy may improve; headaches, heartburn, or constipation.\nAdvice: Follow your local health facility’s recommended malaria prevention timeline.'
      },
      {
        'target_week': 14,
        'title': 'Trimester 2: Proportional Development',
        'body_text': 'Baby: Growth continues; facial movements and body proportions develop.\nNutrition: Local nutrient-dense foods: beans, fresh vegetables, fruit, clean eggs.\nSymptoms: Nasal congestion, mild aches, increased appetite.\nAdvice: Keep active safely if advised by your clinic. Avoid alcohol entirely.'
      },
      {
        'target_week': 15,
        'title': 'Trimester 2: Bone Strengthening',
        'body_text': 'Baby: Bones and muscles develop; movement coordinates.\nNutrition: Protein at meals; iron-rich options; plenty of safe water.\nSymptoms: Backache, constipation, or mild round-ligament discomfort.\nAdvice: Learn pregnancy danger signs and know where to seek emergency triage.'
      },
      {
        'target_week': 16,
        'title': 'Trimester 2: Fetal Activity Spurt',
        'body_text': 'Baby: Fetus grows and becomes active (movement may be felt soon).\nNutrition: Continue varied meals; avoid skipping meals or routines.\nSymptoms: Increased discharge, mild backache, or active heartburn.\nAdvice: Discuss any unusual bleeding, severe pain, or fever with a provider.'
      },
      {
        'target_week': 17,
        'title': 'Trimester 2: Fat Tissue Formation',
        'body_text': 'Baby: Fat and tissue development begins; bones strengthen.\nNutrition: Include calcium-rich and protein-rich foods; maintain hydration.\nSymptoms: Backache, leg cramps, constipation, or persistent heartburn.\nAdvice: Sleep comfortably on your side, stay hydrated, and track symptoms.'
      },
      {
        'target_week': 18,
        'title': 'Trimester 2: Hearing Development',
        'body_text': 'Baby: Hearing structures develop; movements grow stronger.\nNutrition: Focus heavily on balanced meals and iron-rich foods.\nSymptoms: Quickening (fetal movement) may be felt; mild body aches.\nAdvice: An ultrasound assessment may be offered depending on your clinic plan.'
      },
      {
        'target_week': 19,
        'title': 'Trimester 2: Senses Activation',
        'body_text': 'Baby: Nervous system and senses continue developing.\nNutrition: Eat fresh fruits and vegetables daily; include iron sources.\nSymptoms: Heartburn, back pain, and pregnancy skin changes.\nAdvice: Follow routine malaria prevention according to Cameroon national protocols.'
      },
      {
        'target_week': 20,
        'title': 'Trimester 2: Mid-Pregnancy Horizon',
        'body_text': 'Baby: Mid-pregnancy milestone; movement is noticeable.\nNutrition: High protein, iron, folate, calcium, and prescribed supplements.\nSymptoms: Growing abdomen, backache, heartburn, leg cramps.\nAdvice: Mid-pregnancy scan assessment is important. Check fetal growth metrics.'
      },
      {
        'target_week': 21,
        'title': 'Trimester 2: Movement and Swallowing',
        'body_text': 'Baby: Fetus gains size, refines swallowing and active movement.\nNutrition: Fiber-rich foods, fluids, vegetables to manage digestive tracking.\nSymptoms: Constipation, heartburn, backache, increased urination.\nAdvice: Plan safe transport logs and support networks for delivery milestones.'
      },
      {
        'target_week': 22,
        'title': 'Trimester 2: Lung Maturation Core',
        'body_text': 'Baby: Fetus develops brain, lung pathways, and internal organs.\nNutrition: Varied local food profiles; ensure safe hygienic food preparation.\nSymptoms: Pelvic pressure, backache, heartburn, or leg cramps.\nAdvice: Keep emergency contact numbers and nearest reference clinic info ready.'
      },
      {
        'target_week': 23,
        'title': 'Trimester 2: Visibility Spurt',
        'body_text': 'Baby: Growth and organ maturation continue; movement is clear.\nNutrition: Lean protein, green vegetables, legumes, safe fluids.\nSymptoms: Mild swelling may begin; heartburn and backache continue.\nAdvice: Sudden swelling, severe headache, or vision shifts require fast triage.'
      },
      {
        'target_week': 24,
        'title': 'Trimester 2: Brain Development Acceleration',
        'body_text': 'Baby: Brain and lung tracking networks gain weight rapidly.\nNutrition: Balanced nutrition; continue routine iron/folic acid supplements.\nSymptoms: Backache, heartburn, constipation, leg cramps.\nAdvice: Blood sugar and vital screenings should be verified by your midwife.'
      },
      {
        'target_week': 25,
        'title': 'Trimester 2: System Consolidation',
        'body_text': 'Baby: Fetus gains weight; nervous system pathways strengthen.\nNutrition: Iron-rich foods paired with vitamin C items; clean protein.\nSymptoms: Tiredness, back pain, heartburn, and sleep difficulty.\nAdvice: Solidify birth preparedness: transport options, logs, and emergency funds.'
      },
      {
        'target_week': 26,
        'title': 'Trimester 2: Active Movements Matrix',
        'body_text': 'Baby: Rapid brain development continues; movements established.\nNutrition: Balanced meals and adequate fluids; strictly avoid unsafe/raw foods.\nSymptoms: Leg cramps, backache, heartburn, and mild swelling options.\nAdvice: Maintain scheduled ANC appointments and preventive clinical tracking.'
      },

      // Trimester 3 (Weeks 27 to 40)
      {
        'target_week': 27,
        'title': 'Trimester 3: Third Trimester Gateway',
        'body_text': 'Baby: Fetus continues maturing; lung pathways keep developing.\nNutrition: Nutrient-dense foods and prescribed clinic supplements.\nSymptoms: Fatigue, sleep difficulty, backache, heartburn.\nAdvice: Review birth plan structures and key alert symptoms with your provider.'
      },
      {
        'target_week': 28,
        'title': 'Trimester 3: Weight Accumulation',
        'body_text': 'Baby: Third trimester begins; rapid brain/lung maturation.\nNutrition: Regular balanced meals; high protein, iron, calcium, and fluids.\nSymptoms: Shortness of breath, heartburn, backache, frequent urination.\nAdvice: Monitor fetal kick counts daily as instructed by your provider.'
      },
      {'target_week': 29,
      'title': 'Trimester 3: Logistics Check','body_text': 'Baby: Weight gains continue; organ systems strengthen.\nNutrition: High fiber, vegetables, safe water; follow supplement logs.\nSymptoms: Heartburn, constipation, pelvic pressure, insomnia.\nAdvice: Complete essential document folders and confirm transport arrangements.'
      },
      {'target_week': 30,
      'title': 'Trimester 3: Rapid Maturation',
      'body_text': 'Baby: Rapid fat accumulation and brain network growth.\nNutrition: Balanced varied meals; high clean protein and iron lines.\nSymptoms: Backache, swollen feet after activity, frequent urination.\nAdvice: Blood pressure tracking is critical. Seek urgent triage for severe symptoms.'
      },
      {'target_week': 31,
      'title': 'Trimester 3: Pressure Adjustments',
      'body_text': 'Baby: Weight accumulation continues; organs mature further.\nNutrition: Small, frequent, light meals help manage compression heartburn.\nSymptoms: Heartburn, breathlessness, back pain, sleep issues.\nAdvice: Finalize emergency fallback plans and delivery companion roles.'
      },
      {'target_week': 32,
      'title': 'Trimester 3: Preparation Stance'
      ,'body_text': 'Baby: Fetus gains size; tracking active movement patterns is key.\nNutrition: Iron-rich local foods, protein, clean fruits, safe water.\nSymptoms: Pelvic pressure, backache, cramps, frequent urination.\nAdvice: Discuss direct breastfeeding and newborn care strategies with your midwife.'
      },
      {'target_week': 33,
      'title': 'Trimester 3: Final Growth Stretch',
      'body_text': 'Baby: Brain, lung fields, and body fat layers scale upwards.\nNutrition: Regular balanced meals; keep taking prescribed ANC elements.\nSymptoms: Fatigue, ankle swelling, intense heartburn, broken sleep.\nAdvice: Review obstetric danger signs with your family or partner.'
      },
      {'target_week': 34,
      'title': 'Trimester 3: Engagement Metrics',
      'body_text': 'Baby: Most internal organs well developed; weight keeps scaling.\nNutrition: Dense nutrient options and consistent fluid tracking loops.\nSymptoms: Braxton Hicks tightenings, backache, pelvic pressure.\nAdvice: Confirm final delivery facility choice and pack your medical bag.'
      },
      {'target_week': 35,
      'title': 'Trimester 3: Countdown Phase',
      'body_text': 'Baby: Fetus continues weight gain and prepares for labor.\nNutrition: Balanced diet; avoid sugary drinks; maintain high food hygiene.\nSymptoms: Increased pelvic pressure, frequent urination, insomnia.\nAdvice: Keep your scheduled third-trimester ANC appointments active.'
      },
      {'target_week': 36,
      'title': 'Trimester 3: Presentation Alignment',
      'body_text': 'Baby: Fetus is fully developed; position/presentation will be checked.\nNutrition: Balanced meals, iron-dense foods, prescribed clinic supplements.\nSymptoms: High pelvic pressure, backache, Braxton Hicks contractions.\nAdvice: Ask your midwife about fetal position and postpartum family planning.'
      },
      {'target_week': 37,
      'title': 'Trimester 3: Full Term Arrival',
      'body_text': 'Baby: Pregnancy reaches full term; final maturation complete.\nNutrition: Regular light meals; maintain high, steady hydration logs.\nSymptoms: Frequent contractions, pelvic pressure, increased discharge.\nAdvice: Lock transport routes down. Go to clinic immediately for labor signs.'
      },
      {'target_week': 38,
      'title': 'Trimester 3: Maturation Peak',
      'body_text': 'Baby: Final brain and body tuning loops finish.\nNutrition: Balanced meals, safe water, active custom supplements.\nSymptoms: Strong contractions, heavy pelvic pressure, lower back pain.\nAdvice: Stay close to your planned delivery facility; keep emergency contacts ready.'
      },
      {'target_week': 39,
      'title': 'Trimester 3: Delivery Readiness',
      'body_text': 'Baby: Baby is fully ready for birth; tracking weight gains.\nNutrition: Light nutritious meals; maintain continuous hydration profiles.\nSymptoms: Frequent contractions, pelvic pressure, backache.\nAdvice: Monitor signs of labor. Contact your delivery team at the first indicator.'
      },
      {'target_week': 40,
      'title': 'Trimester 3: Estimated Due Date','body_text': 'Baby: Ready for birth. Normal delivery timing varies across mothers.\nNutrition: Regular fluids and easily digestible meals as tolerated.\nSymptoms: Labor may begin; regular, intense, structured contractions.\nAdvice: Seek IMMEDIATE care for heavy bleeding, severe headache/vision shifts, abdominal pain, convulsions, or reduced fetal movement.'
      }
      ];// Clear old placeholder entries to prevent indexing collisionsawait db.delete('educational_content');// Injects all 40 weeks of structured data rows into your internal schema
      for (var article in localizedGuide) {
        await db.insert('educational_content', article);
        }
        debugPrint("SUCCESS: 40-Week  Clinical Education matrix seeded completely offline!");
        }

  // ==========================================
  // DATA ACCESS METHODS (DAO ENGINE CORES)
  // ==========================================

  // Method 1: Inserts the onboarding maternal profile registration data row
  Future<int> saveUserProfile(String name, String phone, String lmp, String edd) async {
    final db = await instance.database;
    await db.delete('users'); // Ensure single active profile without duplicates
    final payload = {
      'name': name,
      'phone': phone,
      'lmp_date': lmp,
      'edd_date': edd,
    };
    return await db.insert('users', payload);
  }

  // Method 1b: Fetches the primary active user profile if one exists
  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('users', limit: 1);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Method 2: Batch inserts the calculated WHO appointment timelines array row list
  Future<void> saveClinicSchedule(List<Map<String, dynamic>> appointments) async {
    final db = await instance.database;
    await db.delete('appointments'); // Clear previous appointments before regenerating
    final batch = db.batch();
    for (var appt in appointments) {
      batch.insert('appointments', appt);
    }
    await batch.commit(noResult: true);
  }

  // Method 3: Inserts a daily symptom log tracking record entry into database storage
  Future<int> saveSymptomLog(String date, String weight, String systolic, String diastolic, String notes) async {
    final db = await instance.database;
    final payload = {
      'logged_date': date,
      'weight': weight,
      'systolic_bp': systolic,
      'diastolic_bp': diastolic,
      'symptom_notes': notes,
    };
    return await db.insert('symptoms', payload);
  }

  // Method 4: Pulls historical logged rows sorted by date context for doctor review outputs
  Future<List<Map<String, dynamic>>> fetchSymptomHistory() async {
    final db = await instance.database;
    return await db.query('symptoms', orderBy: 'logged_date DESC');
  }

  // Method 5: Update the emergency contact number
  Future<void> updateEmergencyContact(String newPhone) async {
    final db = await instance.database;
    await db.update('users', {'phone': newPhone});
  }
}
