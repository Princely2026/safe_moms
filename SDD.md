# Software Design Document (SDD)
## Project Name: SafeMoms

### 1. Introduction
#### 1.1 Purpose
This Software Design Document outlines the architectural and component-level design for the SafeMoms application. It provides a blueprint for the system's structure, data models, and user interface.

### 2. System Architecture
SafeMoms utilizes a simplified **Model-View-Controller (MVC)** architectural pattern, heavily relying on Flutter's reactive UI framework and a local SQLite database for persistence.

- **Presentation Layer (View)**: Flutter Widgets (`screens/` directory) handling UI rendering and user interactions.
- **Business Logic Layer (Controller)**: Dart classes (`EmergencyController`, `GestationalCalculator`, `PdfExporter`) handling core algorithms, hardware interactions, and document generation.
- **Data Access Layer (Model/Database)**: `DatabaseHelper` acting as a Singleton DAO (Data Access Object) to interface with the SQLite engine.

### 3. Component Design
#### 3.1 DatabaseHelper (`database_helper.dart`)
- **Role**: Manages the SQLite database connection and schema initialization.
- **Responsibilities**:
  - Implements the Singleton pattern to maintain a single database connection stream.
  - Seeds static educational content upon initialization.
  - Provides CRUD (Create, Read, Update, Delete) methods for user profiles, appointments, and symptoms.

#### 3.2 EmergencyController (`emergency_controller.dart`)
- **Role**: Handles the SOS functionality.
- **Responsibilities**:
  - Checks for location permissions and queries the hardware GPS sensor via the `geolocator` package.
  - Formats an emergency string containing the user's coordinates.
  - Dispatches a telephony intent using the `flutter_sms` package.

#### 3.3 GestationalCalculator (`gestational_calculator.dart`)
- **Role**: Performs date arithmetic for pregnancy tracking.
- **Responsibilities**:
  - Uses Naegele's Rule to calculate the Estimated Date of Delivery (EDD).
  - Calculates the current gestational week based on Last Menstrual Period (LMP).
  - Generates the 8 WHO Antenatal Care milestone dates based on standard health screening weeks.

#### 3.4 PdfExporter (`pdf_exporter.dart`)
- **Role**: Generates the offline medical reports.
- **Responsibilities**:
  - Uses the `pdf` package to construct an A4 page format layout.
  - Queries `DatabaseHelper` for historical symptom logs.
  - Builds a relational data matrix chart (Table) for doctor review and triggers the native print/share dialog.

### 4. Database Design (Data Model)
The system uses a relational SQLite database (`SafeMoms.db`) with the following core tables:

1. **`users` Table**:
   - `id` (INTEGER PRIMARY KEY)
   - `name` (TEXT)
   - `phone` (TEXT)
   - `lmp_date` (TEXT)
   - `edd_date` (TEXT)

2. **`appointments` Table**:
   - `id` (INTEGER PRIMARY KEY)
   - `title` (TEXT)
   - `scheduled_week` (INTEGER)
   - `target_date` (TEXT)
   - `is_completed` (INTEGER) - Acts as a boolean (0 or 1)

3. **`symptoms` Table**:
   - `id` (INTEGER PRIMARY KEY)
   - `logged_date` (TEXT)
   - `weight` (TEXT)
   - `systolic_bp` (TEXT)
   - `diastolic_bp` (TEXT)
   - `symptom_notes` (TEXT)

4. **`educational_content` Table**:
   - `id` (INTEGER PRIMARY KEY)
   - `target_week` (INTEGER)
   - `title` (TEXT)
   - `body_text` (TEXT)

### 5. User Interface Design Overview
- **Onboarding Screen**: Captures initial profile data (Name, Contact, LMP).
- **Dashboard Screen**: The primary hub displaying the current gestational week, dynamic educational content, and quick action buttons for SOS and Logging.
- **Appointments Screen**: Displays a timeline of WHO antenatal contacts with visual indicators for completion.
- **Log Symptom Screen**: A form interface for entering daily vitals (weight, blood pressure, notes).
