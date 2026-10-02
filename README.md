# SafeMoms: Offline-First Maternal Health Companion

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Database](https://img.shields.io/badge/Database-SQLite%20(Local)-003B57?logo=sqlite)](https://sqlite.org)
[![Tests](https://img.shields.io/badge/Tests-100%25%20Passing-success)](test/widget_test.dart)
[![Architecture](https://img.shields.io/badge/Architecture-Layered%20MVC-blueviolet)]()
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Desktop-lightgrey)]()

**SafeMoms** is a high-reliability, zero-cloud mobile healthcare companion engineered specifically for expectant mothers living in resource-constrained environments. Developed as a Level 2 Software Engineering capstone project, SafeMoms eliminates external server dependencies by executing all gestational calculations, clinical scheduling, vital telemetry tracking, and medical document generation entirely on the local handset device.

---

## 📋 Course & Project Information

* **Course Title:** Introduction to Software Engineering
* **Academic Level:** Level 2 (Undergraduate)
* **Project Topic:** SafeMoms — Offline-First Maternal Health Companion
* **Project Methodology:** Agile / Scrum Development Framework

### 👥 Engineering Team & Roles

| Role | Name | Primary Responsibilities |
| :--- | :--- | :--- |
| **Scrum Master & Team Lead** | **NCHANG PRINCELY TAMUNJONG** | Project coordination, architecture design, SRS/SDD documentation, system integration |
| **Development Team Member** | `[Insert Member 2 Name Here]` | Algorithmic logic (Naegele's Rule, WHO scheduler), unit testing |
| **Development Team Member** | `[Insert Member 3 Name Here]` | UI/UX engineering, Material 3 reactive screens, presentation layer |

### 🔗 Project Links & Resources

* **GitHub Repository:** [https://github.com/Princely2026/safe_moms](https://github.com/Princely2026/safe_moms)
* **Live Deployed App / Demo:** `[Live App Link: Paste Deployed URL Here]`
* **Software Requirements Specification (SRS):** [`SRS.md`](SRS.md)
* **Software Design Document (SDD):** [`SDD.md`](SDD.md)

---

## 🎯 Problem Statement & Motivation

In developing nations across Sub-Saharan Africa (such as Cameroon):
1. **High Maternal Complications:** Preventable obstetric conditions (preeclampsia, hemorrhage, gestational diabetes) often go undetected due to irregular prenatal monitoring.
2. **The Cloud Connectivity Trap:** Mainstream health applications require persistent, expensive 4G/5G mobile data bundles and steady cellular coverage—failing rural and semi-urban mothers when connectivity drops.
3. **Paper Record Fragility:** Traditional paper antenatal booklets are easily misplaced, torn, or unavailable during late-night emergencies.
4. **Emergency Triage Delay:** In acute distress, patients struggle to communicate accurate physical coordinates to emergency contacts.

**SafeMoms solves these challenges by providing a 100% offline, privacy-first, zero-data digital health companion.**

---

## 🌟 Key Software Features & Engineering Pillars

```
+-----------------------------------------------------------------------------------+
|                                  SAFEMOMS CORE                                    |
+-------------------------+-------------------------------+-------------------------+
|   CLINICAL SCHEDULING   |       DAILY TELEMETRY         |    EMERGENCY TRIAGE     |
| • Naegele's Rule (EDD)  | • Weight Tracking (kg)        | • Hardware GPS Lock     |
| • WHO 8-Milestone ANC   | • Blood Pressure (mmHg)       | • 10s Timeout Fallback  |
| • Trimester Progress    | • Symptom Notes & Warnings    | • Carrier Wave SMS      |
+-------------------------+-------------------------------+-------------------------+
|    OFFLINE INSIGHTS     |       LOCAL DATABASE          |     DOCTOR REPORTS      |
| • Pre-seeded Articles   | • SQLite Transaction Engine   | • Client-Side A4 PDF    |
| • Nutrition & Danger    | • Zero Cloud Leaks (Private)  | • Chronological Tables  |
| • Week-by-Week Advice   | • ACID-Compliant Persistence  | • Native Share & Print  |
+-------------------------+-------------------------------+-------------------------+
```

### 1. Algorithmic Gestational Timeline (Naegele's Rule)
Dynamically computes the Estimated Date of Delivery (EDD) and current gestational week directly from the mother's Last Menstrual Period (LMP) using strict obstetric date arithmetic with boundary protection ($1 \le \text{week} \le 40$).

### 2. Automated WHO 8-Contact Milestone Scheduler
Translates World Health Organization antenatal guidelines into 8 scheduled clinical visits (Weeks 12, 20, 26, 30, 34, 36, 38, and 40). Appointments are dynamically written to the local database with completion toggles.

### 3. Local Relational Telemetry Logging
Enables expectant mothers to track daily vitals—weight (kg), systolic/diastolic blood pressure (mmHg), and free-text symptom logs—persisted entirely in an embedded SQLite database.

### 4. Hardware-Integrated Emergency SOS Triage
A persistent, high-contrast floating emergency trigger. It queries the device GPS sensor with a 10-second accuracy timeout and resilient fallback to last-known cached coordinates, dispatching an immediate SMS alert with a Google Maps link via cellular telephony carrier waves (functions with zero mobile data balance).

### 5. Client-Side Clinical PDF Exporter Engine
Compiles SQLite symptom rows into an international A4 medical document with patient metadata, chronological telemetry tables, and legal clinical disclaimers. Directly launches native print and share sheets for clinical consultations.

### 6. Pre-Seeded Localized Pregnancy Education
Seeds a comprehensive database matrix of week-by-week maternal advice covering nutrition, fetal development, and danger signs upon first app boot.

---

## 🏗️ Software Architecture (Layered MVC)

SafeMoms implements a strict **Model-View-Controller (MVC)** architectural pattern to ensure loose coupling, high cohesion, and testability:

```
[ Presentation Layer (View) ]
  ├── OnboardingScreen        -> Captures maternal name, phone, LMP date
  ├── DashboardScreen         -> Gestational progress bar, insights, quick actions
  ├── AppointmentsScreen      -> Interactive WHO antenatal care milestone checklist
  └── LogSymptomScreen        -> Form for weight, blood pressure, and symptom notes
          │
          ▼  (State & User Interactions)
[ Business Logic Layer (Controller) ]
  ├── GestationalCalculator   -> Naegele's Rule, week clamping, WHO date generator
  ├── EmergencyController     -> GPS sensor hooks, timeout fallback, carrier SMS
  └── PdfExporter             -> In-memory A4 document layout and native share triggers
          │
          ▼  (Transactions & Data Access)
[ Data Access Layer (Model / Persistence) ]
  ├── DatabaseHelper (DAO)    -> Thread-safe Singleton managing SQLite connection pool
  ├── SymptomLog Model        -> Object-Relational mapping (toMap / fromMap)
  └── SafeMoms.db             -> Local relational SQLite storage (Zero cloud exposure)
```

---

## 🗄️ Database Design (SQLite Relational Schema)

The embedded SQLite database (`SafeMoms.db`) consists of five normalized tables:

| Table | Primary Columns | Purpose |
| :--- | :--- | :--- |
| **`users`** | `id`, `name`, `phone`, `lmp_date`, `edd_date` | Maternal profile, emergency contact, and pregnancy baseline |
| **`appointments`** | `id`, `title`, `scheduled_week`, `target_date`, `is_completed` | The 8 WHO antenatal contact milestones and completion states |
| **`symptoms`** | `id`, `logged_date`, `weight`, `systolic_bp`, `diastolic_bp`, `symptom_notes` | Daily clinical vitals and symptom progression logs |
| **`educational_content`** | `id`, `target_week`, `title`, `body_text` | Week-by-week maternal healthcare tips and warning signs |
| **`emergency_contacts`** | `id`, `contact_name`, `phone_number` | Pre-saved emergency rescue phone contacts |

---

## 🧪 Verification & Automated Testing

The project maintains an automated test suite ([`test/widget_test.dart`](test/widget_test.dart)) guaranteeing algorithmic correctness and UI stability.

### Test Execution Command
```bash
flutter test
```

### Verified Test Suites (100% Passing)
* **GestationalCalculator Tests:**
  * ✅ `calculateEDD`: Verifies delivery date prediction via Naegele's Rule ($\text{LMP} + 7\text{d} + 1\text{y} - 3\text{m}$).
  * ✅ `calculateCurrentPregnancyWeek`: Validates boundary clamping ($week \ge 1$ and $week \le 40$).
  * ✅ `generateWHOSchedule`: Confirms generation of exactly 8 WHO checkup records across weeks 12 to 40.
* **SymptomLog Model Tests:**
  * ✅ `toMap` & `fromMap`: Validates byte-accurate serialization and deserialization between Dart objects and SQLite rows.
* **PdfExporter Tests:**
  * ✅ `buildPdfDocument`: Compiles multi-page PDF document buffers without layout exceptions or memory leaks.
* **App Smoke Test:**
  * ✅ Headless `WidgetTester` verifies proper rendering of the onboarding flow on initial boot.

---

## 💻 Technical Implementation Stack

* **UI Framework:** [Flutter](https://flutter.dev) (v3.x, Material 3 Design)
* **Language:** [Dart](https://dart.dev) (v3.x with sound null-safety)
* **Local Persistence:** [`sqflite`](https://pub.dev/packages/sqflite) & [`sqflite_common_ffi`](https://pub.dev/packages/sqflite_common_ffi) (Desktop & Mobile)
* **Hardware Sensors:** [`geolocator`](https://pub.dev/packages/geolocator) (Device GPS chipset)
* **Telephony Carrier Dispatch:** [`flutter_sms`](https://pub.dev/packages/flutter_sms)
* **Document Compilation:** [`pdf`](https://pub.dev/packages/pdf) & [`printing`](https://pub.dev/packages/printing)
* **Build Configuration:** Gradle with Kotlin DSL (`build.gradle.kts`) and core library desugaring

---

## 🚀 Getting Started & Local Installation

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed ($\ge 3.13.0$)
* [Android Studio](https://developer.android.com/studio) or VS Code with Flutter extension
* Android Device / Emulator OR Windows Desktop build tools

### 1. Clone the Repository
```bash
git clone https://github.com/Princely2026/safe_moms.git
cd safe_moms
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run Automated Tests
```bash
flutter test
```

### 4. Run the Application
* **On Android Device / Emulator:**
  ```bash
  flutter run
  ```
* **On Windows Desktop:**
  ```bash
  flutter run -d windows
  ```

---

## 🔮 Scalability & Future Roadmap

* **Multilingual Audio Guidance:** Expand localized educational content into French and Cameroon Pidgin English audio tracks for illiterate mothers.
* **Peer-to-Peer Bluetooth Sync:** Implement offline BLE data transmission from the mother's phone directly to rural clinic nurse tablets.
* **On-Device Machine Learning:** Deploy a lightweight TensorFlow Lite edge model to detect preeclampsia risk patterns from blood pressure telemetry.
* **USSD Fallback Protocol:** Expand emergency SOS capabilities to non-smartphone feature phones.

---

## 📄 License & Academic Attribution

This project is developed as part of the **Introduction to Software Engineering (Level 2)** curriculum. All software engineering artifacts—including the SRS, SDD, automated tests, and implementation—are documented for academic presentation and evaluation.