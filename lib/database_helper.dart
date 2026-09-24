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
    final List<Map<String, dynamic>> staticArticles = [
      {
        'target_week': 4,
        'title': 'First Trimester: Implantation & Early Care',
        'body_text': 'Your body is adjusting rapidly. Focus on starting folic acid supplements daily, staying well hydrated, and getting plenty of rest.'
      },
      {
        'target_week': 8,
        'title': 'First Trimester: Baby\'s Heartbeat',
        'body_text': 'Baby\'s tiny heart is beating rapidly! Morning nausea may peak around this time; eat small, frequent meals and drink ginger or lemon water.'
      },
      {
        'target_week': 12,
        'title': 'End of 1st Trimester: Milestone Contact',
        'body_text': 'All essential organs are formed. Schedule your WHO Contact 1 for clinical baseline assessment, blood tests, and ultrasound verification.'
      },
      {
        'target_week': 14,
        'title': 'Baby\'s Size: Week 14',
        'body_text': 'Your baby is now the size of a lemon! Their facial muscles are training, allowing tiny squinting and swallowing movements.'
      },
      {
        'target_week': 14,
        'title': 'Second Trimester Nutrition',
        'body_text': 'Your blood volume is expanding. Eat clean, iron-rich local foods like fresh spinach, beans, and organic meats to actively prevent anemia.'
      },
      {
        'target_week': 20,
        'title': 'Second Trimester: Halfway Milestone',
        'body_text': 'You have reached the halfway mark! Baby can hear outside voices and music. This is the optimal time for the WHO Anomaly Assessment scan.'
      },
      {
        'target_week': 26,
        'title': 'Second Trimester: Rapid Growth',
        'body_text': 'Baby\'s eyes open and lungs develop air sacs. Stay active with gentle walking and ensure calcium intake for baby\'s strong bone structure.'
      },
      {
        'target_week': 28,
        'title': 'Welcome to the Third Trimester',
        'body_text': 'The final stretch begins! Begin tracking baby\'s daily kicks and movements. Seek immediate clinical care if you notice decreased movement.'
      },
      {
        'target_week': 34,
        'title': 'Third Trimester: Fetal Growth Monitoring',
        'body_text': 'Baby is gaining weight rapidly and bones are hardening. Keep monitoring your blood pressure and report any severe headaches or sudden swelling.'
      },
      {
        'target_week': 36,
        'title': 'Third Trimester: Delivery Readiness',
        'body_text': 'Prepare your hospital bag and review your transport plan to the health center. Know your designated support person and emergency contact.'
      },
      {
        'target_week': 40,
        'title': 'Full Term: Welcoming Baby',
        'body_text': 'Your baby is fully developed and ready to meet you! Watch for true labor contractions: steady, regular, and increasing in intensity.'
      }
    ];

    for (var article in staticArticles) {
      await db.insert('educational_content', article);
    }
    debugPrint("SQLite Relational Database engine fully initialized and seeded with articles!");
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
