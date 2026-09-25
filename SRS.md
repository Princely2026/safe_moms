# Software Requirements Specification (SRS)
## Project Name: SafeMoms

### 1. Introduction
#### 1.1 Purpose
The purpose of this document is to define the software requirements for the SafeMoms application. SafeMoms is a mobile health application designed to assist pregnant mothers in tracking their pregnancy, managing health milestones, and ensuring maternal safety through offline features.

#### 1.2 Scope
SafeMoms provides a localized, offline-first digital health record system. It includes features for calculating estimated delivery dates, tracking World Health Organization (WHO) antenatal care milestones, logging daily symptoms (weight, blood pressure), reading educational pregnancy content, exporting medical reports, and an emergency SOS system.

### 2. Overall Description
#### 2.1 Product Perspective
SafeMoms is a standalone mobile application built using the Flutter framework. It relies on a local SQLite database for offline data storage, ensuring that mothers in low-connectivity areas can access critical information and health records.

#### 2.2 User Classes and Characteristics
- **Pregnant Mothers**: Primary users who log symptoms, track pregnancy weeks, and read educational materials.
- **Healthcare Providers (Doctors/Nurses)**: Secondary users who review the generated PDF medical reports to make clinical decisions.
- **Emergency Contacts (Next-of-Kin)**: Individuals who receive SMS alerts with GPS coordinates in case of a maternal emergency.

#### 2.3 Operating Environment
- Operating System: Android / iOS / Desktop (Windows/Linux support via sqflite_ffi)
- Hardware constraints: Requires GPS sensor for emergency SOS features and telephony support for SMS broadcasting.

### 3. System Features
#### 3.1 Maternal Profile & Gestational Tracking
- **Description**: The system must allow users to input their Name, Phone, and Last Menstrual Period (LMP) date to calculate the Estimated Date of Delivery (EDD) using Naegele's Rule.
- **Requirements**: Calculates the current pregnancy week automatically based on the LMP.

#### 3.2 WHO Antenatal Care Scheduling
- **Description**: The system automatically generates 8 WHO-recommended antenatal care milestones based on the user's LMP.
- **Requirements**: Generates exact calendar dates for checkups and tracks completion status.

#### 3.3 Daily Symptom Logging
- **Description**: Users can log daily health metrics.
- **Requirements**: Captures weight, systolic/diastolic blood pressure, and clinical symptom notes.

#### 3.4 Offline PDF Medical Report Export
- **Description**: The system can compile logged symptom data into a formatted PDF document.
- **Requirements**: Uses `pdf` and `printing` packages to generate the report and trigger the native file saver for sharing with doctors.

#### 3.5 Emergency SOS Protocol
- **Description**: In emergencies, the system broadcasts an SMS to a pre-saved next-of-kin.
- **Requirements**: Retrieves GPS coordinates (or falls back to last known location) and sends an SMS containing a Google Maps link to the emergency contact.

#### 3.6 Offline Educational Insights
- **Description**: Provides static offline articles regarding pregnancy milestones.
- **Requirements**: Seeded into the local database upon initialization, providing week-specific health tips.

### 4. Non-Functional Requirements
#### 4.1 Performance Requirements
- The application must load the dashboard and database within 2 seconds.
- PDF generation must happen locally without internet dependency.

#### 4.2 Reliability and Availability
- The core database and educational content must be 100% available offline.
- The SOS feature must implement a timeout fallback for GPS locking to ensure SMS delivery is not blocked by poor satellite connectivity.

#### 4.3 Security and Privacy
- All medical data (symptoms, profile) is stored locally on the device using SQLite. No cloud synchronization is used to ensure strict data privacy.
