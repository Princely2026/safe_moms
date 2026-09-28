# SafeMoms - Offline-First Maternal Health Companion

**SafeMoms** is a mobile application engineered to provide high-reliability maternal healthcare monitoring entirely offline. Designed specifically to overcome infrastructure constraints such as expensive mobile data and fluctuating network coverage, the application operates with zero external server dependencies, protecting maternal health metrics locally on the handset device handset.

## Key Software Features & Engineering Pillars

*   **Algorithmic Gestational Timeline (Naegele's Rule):** Automates the calculation of the Estimated Date of Delivery (EDD) and current pregnancy progress parameters dynamically using the mother's Last Menstrual Period (LMP) input.
*   **Automated Antenatal Schedule Generation:** Dynamically populates and schedules the 8 mandatory World Health Organization (WHO) clinical antenatal checkup milestones directly into a client-side database table.
*   **Relational Database Content Filtering:** Employs an embedded client-side database engine to run zero-data, locally filtered queries that display tailored health and nutritional text cards matching the user's precise week.
*   **Hardware Integrated Emergency SOS Triage:** A high-contrast, persistent floating interface shortcut that captures raw device GPS coordinates and dispatches localized SMS distress alerts to a rescue contact using direct telephony carrier waves.
*   **Clinical Report Exporter Engine:** Aggregates daily symptom logs, weight, and blood pressure telemetry matrices into a clean, structured, doctor-ready PDF clinical document completely offline.


## Technical Implementation Stack

*   **Frontend Framework:** Flutter (Dart Programming Language) using a strict separation of presentation and logic layers.
*   **Data Storage Layer:** Local SQLite Relational Database Management System via the `sqflite` transaction engine.
*   **System Hardware Hooks:** Core Android Location GPS Services and Background Telephony Carrier Messaging (`geolocator`, `flutter_sms`, `printing`, `pdf`).
*   **Build Architecture System:** Modern Android Gradle Plugin (AGP 9+) with Kotlin DSL configuration standard (`build.gradle.kts`) and core library desugaring compatibility switches enabled.