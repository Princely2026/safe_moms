# SafeMoms: Level 2 Software Engineering Group Presentation Guide & Defense Handbook

**Course:** Introduction to Software Engineering (Level 2)  
**Project Title:** SafeMoms — Offline-First Maternal Health Companion  
**Primary Deliverables:**
* PowerPoint Slide Deck: [`SafeMoms_Level2_Presentation.pptx`](file:///c:/Develop/project/safe_moms/SafeMoms_Level2_Presentation.pptx)
* Software Requirements Specification: [`SRS.md`](file:///c:/Develop/project/safe_moms/SRS.md)
* Software Design Document: [`SDD.md`](file:///c:/Develop/project/safe_moms/SDD.md)
* Complete Source Code: [`lib/`](file:///c:/Develop/project/safe_moms/lib)
* Automated Test Suite: [`test/widget_test.dart`](file:///c:/Develop/project/safe_moms/test/widget_test.dart)

---

## 1. Executive Presentation Overview

| Metric | Target Standard |
| :--- | :--- |
| **Target Presentation Duration** | 12 to 15 Minutes (+ 5 Minutes Q&A) |
| **Number of Slides** | 16 Widescreen (16:9) High-Impact Slides |
| **Audience** | Software Engineering Lecturers, External Examiners, Peers |
| **Core Software Engineering Themes** | Agile SDLC, SRS (IEEE 830), SDD (MVC & Layered Architecture), Relational SQLite Data Modeling, Boundary Condition Testing, Hardware Interfacing, Fault-Tolerant Fallback Mechanisms |

---

## 2. Team Member Allocation & Speaking Roles

| Member | Primary Project Module | Presentation Role | Speaking Slides |
| :--- | :--- | :--- | :--- |
| **Member 1 (Team Lead)** | System Architecture & SRS/SDD | Introduction, Problem Statement, SDLC, & SRS Specifications | Slides 1, 2, 4, 5 |
| **Member 2** | Gestational Engine & Mathematics | Algorithmic Computations (Naegele's Rule, WHO Milestones) | Slides 3, 8 |
| **Member 3** | UI/UX & Presentation Layer | Reactive Flutter Widgets, Material 3 Design, & Live Demo | Slides 6, 11 |
| **Member 4** | Data Access Layer & Reporting | SQLite Relational Schema, DAO, & Clinical PDF Engine | Slides 7, 10 |
| **Member 5** | Hardware Systems & QA Lead | GPS Hardware Triage, Carrier SMS, Automated Testing, & Defense | Slides 9, 12, 13, 14, 15, 16 |

*(Note: If your group has 3 or 4 members, combine Member 2 & 5 or Member 1 & 3 as appropriate).*

---

## 3. Slide-by-Slide Content & Word-for-Word Speaker Scripts

### Slide 1: Title & Group Identification
* **Visuals:** Dark Navy theme, Maternal Rose accent badge, project metadata, team member names and module breakdown.
* **Speaker (Member 1):**
> *"Good morning / afternoon distinguished examiners, lecturers, and colleagues. Welcome to our presentation for the Introduction to Software Engineering Level 2 Exam. Our project is titled **SafeMoms: An Offline-First Maternal Health Companion**. Over the next 15 minutes, our team will demonstrate how we applied disciplined Software Engineering principles—from requirements elicitation and layered architectural design, to relational data modeling and automated testing—to engineer a zero-cloud mobile healthcare system designed specifically for resource-constrained environments."*

---

### Slide 2: Background & Problem Statement
* **Visuals:** 3 Problem Cards: 1. Healthcare Gap (Maternal mortality, missed checkups), 2. Digital Constraints (Expensive mobile data, fluctuating coverage), 3. Emergency Triage Void (Delayed obstetric notifications).
* **Speaker (Member 1):**
> *"Every software engineering solution begins with a real problem. In developing nations and rural communities across Sub-Saharan Africa, maternal mortality remains alarming. While the World Health Organization recommends 8 clinical antenatal checkups, paper-based records are frequently lost, and appointments are forgotten. Moreover, existing health apps make a fatal architectural assumption: constant, cheap internet connectivity. When cellular networks drop or data packages run out, cloud-dependent apps fail completely. Our goal was to eliminate this single point of failure."*

---

### Slide 3: Proposed Solution & Core Vision
* **Visuals:** 4 Engineering Pillars: 1. Zero-Cloud Standalone Persistence, 2. Algorithmic Medical Automation, 3. Hardware-Integrated SOS, 4. Offline Clinical PDF Exporter.
* **Speaker (Member 2):**
> *"To solve this, we engineered SafeMoms around four software engineering pillars: First, **Data Sovereignty through Zero-Cloud Persistence**—storing 100% of maternal records locally in an embedded SQLite database. Second, **Algorithmic Medical Automation**—dynamically computing gestational timelines via Naegele's rule and scheduling WHO checkups. Third, **Hardware-Integrated Emergency Triage**—querying GPS sensors and dispatching carrier-wave SMS without internet data. And fourth, a **Clinical PDF Engine** that compiles doctor-ready health records in memory on the handset."*

---

### Slide 4: Software Development Life Cycle (SDLC)
* **Visuals:** 5-Phase Horizontal Agile Pipeline: Requirements (SRS) $\rightarrow$ Architectural Design (SDD) $\rightarrow$ Sprint Implementation $\rightarrow$ Verification & Validation (V&V) $\rightarrow$ Evaluation & Packaging.
* **Speaker (Member 1):**
> *"In accordance with Level 2 Software Engineering standards, we followed an iterative Agile development process. We began with formal Requirements Elicitation, producing an IEEE-compliant Software Requirements Specification (SRS). Next, we created our Software Design Document (SDD), establishing an MVC architecture and relational database schema before writing any code. We then executed sprint-based implementation, backed by automated unit and smoke testing, ensuring continuous integration and zero runtime regressions."*

---

### Slide 5: Requirements Engineering (SRS Analysis)
* **Visuals:** Two Comparative Columns: Functional Requirements (FR1 to FR6) vs. Non-Functional Requirements (NFR1 to NFR6).
* **Speaker (Member 1):**
> *"Our SRS mapped user needs into verifiable engineering requirements. On the functional side: FR1 calculates gestational progress and EDD; FR2 generates the 8 WHO antenatal appointments; FR3 captures daily vitals like blood pressure and weight; FR4 serves localized offline pregnancy articles; FR5 exports clinical PDF documents; and FR6 triggers our emergency SMS protocol. Crucially, our Non-Functional Requirements enforced strict parameters: 100% offline availability, cold-boot startup in under 2 seconds, and total local data privacy with zero third-party cloud exfiltration."*

---

### Slide 6: System Architecture (Layered MVC Pattern)
* **Visuals:** 3 Layer Cards: Presentation Layer (Views: Flutter Widgets), Business Logic Layer (Controllers: GestationalCalculator, EmergencyController, PdfExporter), Data Access Layer (Model/DAO: DatabaseHelper Singleton & SQLite).
* **Speaker (Member 3):**
> *"To maintain high cohesion and loose coupling, SafeMoms implements a layered Model-View-Controller architecture. The **Presentation Layer** contains reactive Flutter widgets including our Dashboard, Onboarding, and Vitals Logging screens. The **Controller Layer** contains pure Dart classes that isolate business logic and hardware interactions away from the UI. The **Data Access Layer** uses the Singleton pattern in `DatabaseHelper` to manage our SQLite transaction stream. This strict separation allowed team members to develop and test their modules concurrently."*

---

### Slide 7: Database Design (SQLite Relational Model)
* **Visuals:** 4 Entity Schema Cards: `users`, `appointments`, `symptoms`, `educational_content` with column types and primary keys.
* **Speaker (Member 4):**
> *"Our persistent layer uses SQLite via the `sqflite` engine. We normalized the schema into five dedicated tables: `users` anchors the mother's profile and LMP date; `appointments` stores the 8 WHO milestones with a completion flag; `symptoms` maintains a chronological electronic health record of weight, systolic and diastolic blood pressure, and clinical notes; and `educational_content` is pre-seeded with week-by-week nutrition and warning-sign articles upon database initialization. All transactions execute locally on device storage."*

---

### Slide 8: Algorithmic Foundations
* **Visuals:** Formula breakdown for Naegele's Rule ($EDD = LMP + 7\text{ days} + 1\text{ year} - 3\text{ months}$), Boundary Clamping ($1 \le \text{week} \le 40$), and WHO 8-Milestone generation loop.
* **Speaker (Member 2):**
> *"In `gestational_calculator.dart`, we implemented Naegele's Rule—the internationally recognized obstetric formula for calculating the Estimated Date of Delivery. Furthermore, we implemented boundary clamping: if a user enters an anomalous date, gestational week is securely clamped between Week 1 and 40 to protect the UI. Our WHO milestone generator programmatically converts target clinical weeks—specifically Weeks 12, 20, 26, 30, 34, 36, 38, and 40—into exact physical calendar days relative to the mother's LMP and records them into SQLite."*

---

### Slide 9: Hardware Integration & Emergency SOS Protocol
* **Visuals:** 3-Stage Hardware Flow: GPS Sensor Lock $\rightarrow$ 10s Timeout Fallback to Last Known Position $\rightarrow$ Telephony Carrier SMS Intent.
* **Speaker (Member 5):**
> *"Obstetric emergencies such as eclampsia require immediate response. In `emergency_controller.dart`, we bridged Flutter to native Android hardware sensors. When the emergency button is pressed, the system queries the GPS sensor. To prevent freezing in dense foliage or indoors, we engineered a strict 10-second timeout that gracefully falls back to the operating system's last known cached location. The alert message—containing a direct Google Maps link—is dispatched via telephony carrier waves using SMS, meaning it delivers even when cellular data is completely zero."*

---

### Slide 10: Clinical Report Engine (Offline PDF Synthesis)
* **Visuals:** A4 Clinical PDF layout breakdown: Document Header, Patient Meta Card, Relational Vitals Data Table, Legal Disclaimer, Native Share Sheet.
* **Speaker (Member 4):**
> *"Rural health centers often lack desktop computers or integrated Electronic Health Record systems. In `pdf_exporter.dart`, we built an in-memory PDF synthesis engine using the `pdf` and `printing` packages. The engine queries the local `symptoms` table, constructs a standardized A4 clinical document with chronological blood pressure telemetry and doctor notes, and invokes the operating system's native share and print sheet. This allows attending physicians to review 40 weeks of vital trends in 30 seconds."*

---

### Slide 11: UI/UX Engineering & Live Demonstration
* **Visuals:** 4 Screen Walkthrough Cards: Onboarding Flow, Dashboard with Gestational Progress Bar, WHO Appointment Tracker, and Floating Red SOS Action Button.
* **Speaker (Member 3):**
> *"Our user interface prioritizes accessibility and cognitive clarity. Using Google's Material 3 design, we implemented an encouraging rose-pink theme. The central dashboard presents an intuitive gestational progress indicator showing current week and completion percentage, upcoming WHO appointments, and trimester-specific advice. The high-contrast red emergency button is rendered as a persistent large Floating Action Button, guaranteeing it is accessible in a single tap without navigating deep menus."*
*(At this point, perform a brief 90-second live demonstration or show the emulator screen).*

---

### Slide 12: Verification & Validation (Testing Suite)
* **Visuals:** Test Pyramid Breakdown: Automated Unit Tests (`GestationalCalculator`, `SymptomLog`, `PdfExporter`) + Headless Widget Smoke Tests (`WidgetTester`).
* **Speaker (Member 5):**
> *"In software engineering, untested code is incomplete code. In `test/widget_test.dart`, we built a test suite with 100% passing rate. We verified Naegele's rule calculations against known dates, verified boundary clamping, tested that `generateWHOSchedule` produces exactly 8 milestones, and validated that `SymptomLog` serialization functions maintain byte-level fidelity. Furthermore, we used Flutter's `WidgetTester` to perform headless smoke testing, proving that UI widgets, forms, and buttons mount cleanly without layout overflow."*

---

### Slide 13: Team Project Management & Module Allocation
* **Visuals:** Matrix of the 5 Team Members with respective software engineering responsibilities, deliverables, and Git collaboration workflows.
* **Speaker (Member 5):**
> *"A critical component of this Level 2 project was demonstrating collaborative software engineering. We divided responsibilities across five distinct areas: Member 1 managed requirements and system documentation; Member 2 authored the gestational algorithms; Member 3 implemented the reactive UI screens; Member 4 developed the database layer and PDF compiler; and Member 5 integrated hardware GPS, SMS, and automated testing. All code was merged and reviewed using Git."*

---

### Slide 14: Engineering Challenges & Technical Trade-offs
* **Visuals:** 4 Challenge & Mitigation Cards: Modern Android Permissions, Desktop/Mobile SQLite FFI Compatibility, GPS Remote Timeouts, Zero-Data Content Seeding.
* **Speaker (Member 5):**
> *"During development, we resolved four major technical hurdles: First, modern Android permission restrictions required implementing asynchronous permission negotiation before querying sensors. Second, to enable cross-platform desktop development, we integrated `sqflite_common_ffi` with conditional platform detection in `main.dart`. Third, we eliminated GPS hanging with timeout fallbacks. And fourth, to guarantee zero-data education, we pre-seeded all medical content directly into SQLite during schema creation."*

---

### Slide 15: Scalability & Future Roadmap
* **Visuals:** 3 Expansion Vectors: 1. Multilingual Audio Localization (French, English, Pidgin), 2. Peer-to-Peer Bluetooth Clinic Sync, 3. On-Device Edge ML for Preeclampsia Risk Detection.
* **Speaker (Member 5):**
> *"Looking forward, SafeMoms has a clear scalability roadmap. We plan to integrate multilingual support—including French and Pidgin English audio guidance for illiterate users. Second, we aim to implement peer-to-peer Bluetooth Low Energy syncing, allowing mothers to transmit their vitals directly to clinic nurse tablets without internet. Third, we plan to embed lightweight on-device machine learning models to detect preeclampsia risk patterns directly on the handset."*

---

### Slide 16: Conclusion & Technical Defense
* **Visuals:** Summary of Key Outcomes, Academic Defense Readiness, and Anticipated Questions & Answers.
* **Speaker (Member 1):**
> *"In conclusion, SafeMoms demonstrates how disciplined Software Engineering principles—from formal SRS and SDD documentation to modular MVC architecture and automated verification—can solve critical real-world healthcare challenges in resource-constrained environments. By engineering an offline-first, zero-cloud architecture, we have delivered a dependable, life-saving companion for mothers. We thank our lecturers and examiners for their mentorship, and we now welcome your questions."*

---

## 4. Anticipated Exam Defense Questions & Model Answers

### Question 1: "Why did you choose SQLite instead of Firebase or a Cloud Backend?"
* **Model Answer:**
  > *"Cloud-first architectures like Firebase assume continuous, affordable internet connectivity. In our target demographic (rural and suburban Cameroon and Sub-Saharan Africa), mobile data is costly and cellular coverage fluctuates dramatically. If a mother experiences an obstetric emergency or needs to log vitals in a dead zone, a cloud-dependent app fails. SQLite provides zero-latency, 100% offline availability, zero bandwidth costs, and guarantees absolute patient privacy because medical records never leave the device without consent."*

### Question 2: "How does your emergency SOS system function if GPS satellite lock fails?"
* **Model Answer:**
  > *"We implemented a multi-stage resilient fallback in `EmergencyController.dart`. The Geolocator queries GPS sensors with a strict 10-second timeout. If satellite acquisition fails or times out (for example, indoors or under heavy foliage), the system catches the exception and immediately queries the device's last known cached position. If no location data is obtainable, the system still immediately fires the telephony SMS intent with a priority distress message to the next-of-kin. Life-critical triage is never blocked by a sensor timeout."*

### Question 3: "How does the system ensure data integrity across app restarts?"
* **Model Answer:**
  > *"We utilize the Singleton pattern in `DatabaseHelper.dart` to maintain a single, thread-safe database connection. During initialization, SQLite's transactional `_createDB()` creates normalized tables with strict `NOT NULL` constraints and autoincrement primary keys. All user profiles, WHO checkups, and symptom logs are committed immediately via atomic SQL transactions (`insert`, `update`), ensuring ACID properties locally."*

### Question 4: "Explain the algorithm used for Estimated Date of Delivery (EDD)."
* **Model Answer:**
  > *"We implemented Naegele's Rule in `GestationalCalculator.dart`: $\text{EDD} = \text{LMP} + 7\text{ days} + 1\text{ year} - 3\text{ months}$. In Dart, we take the user's selected LMP `DateTime`, add 7 days, add 365 days, and subtract 90 days. We also calculate the current gestational week by dividing the difference in days between today and the LMP by 7, with boundary clamping ensuring the value remains strictly within human gestational bounds of 1 to 40 weeks."*

### Question 5: "What testing strategies did you apply to validate your software?"
* **Model Answer:**
  > *"We implemented a dual testing strategy in `test/widget_test.dart`: First, automated Unit Tests to verify our algorithmic logic (Naegele's rule accuracy, boundary clamping, WHO 8-milestone array generation, data model serialization, and PDF byte compilation). Second, Widget Smoke Testing using Flutter's `WidgetTester` to mount the application headlessly, pump frames, and verify that form fields, headers, and navigation routes instantiate without runtime exceptions."*

---

## 5. Live Demonstration Checklist (Step-by-Step)

1. **Launch App:** Run on Android Emulator or Windows Desktop (`flutter run -d windows` or `-d android`).
2. **First-Time Boot (Onboarding Screen):**
   * Demonstrate form validation: enter Patient Name, Phone number, and select an LMP date using the native date picker.
   * Tap **"Generate My Calendar"** $\rightarrow$ Highlight that the SQLite database creates the profile and computes the 8 WHO milestones instantly.
3. **Dashboard Screen:**
   * Point out the **Pregnancy Progress Bar** showing dynamic percentage and current gestational week.
   * Point out the **Upcoming WHO Checkup Card** showing the next required appointment.
   * Point out the **Localized Health Insights** seeded from the local database.
4. **WHO Appointments Schedule:**
   * Tap the calendar icon in the app bar $\rightarrow$ Navigate to `AppointmentsScreen`.
   * Tap a checkbox next to "1st Contact: Early Scan" $\rightarrow$ Show the instant green checkmark and strikethrough, explaining how it updates the SQLite `is_completed` column.
5. **Log Daily Vitals:**
   * Tap the vitals shortcut $\rightarrow$ Open `LogSymptomScreen`.
   * Enter weight (e.g. `68`), systolic BP (`120`), diastolic BP (`80`), and a symptom note $\rightarrow$ Save and return to dashboard.
6. **PDF Medical Report Generation:**
   * Tap **"Export Doctor Report (PDF)"** $\rightarrow$ Show the system compiling the SQLite rows into an A4 table layout and launching the native preview/share dialog.
7. **Emergency SOS Demonstration:**
   * Tap the prominent red **SOS** Floating Action Button.
   * Show the snackbar confirming GPS acquisition and the telephony intent launching with coordinates and pre-filled emergency SMS text.
