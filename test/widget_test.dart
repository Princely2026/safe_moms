import 'package:flutter_test/flutter_test.dart';
import 'package:safe_moms/gestational_calculator.dart';
import 'package:safe_moms/symptom_model.dart';
import 'package:safe_moms/pdf_exporter.dart';
import 'package:safe_moms/main.dart';

void main() {
  group('GestationalCalculator Tests', () {
    test('calculateEDD calculates expected delivery date using Naegele rule', () {
      final lmp = DateTime(2026, 1, 1);
      final edd = GestationalCalculator.calculateEDD(lmp);

      // LMP (Jan 1) + 7 days + 365 days - 90 days = Oct 10, 2026
      expect(edd.year, 2026);
      expect(edd.month, 10);
      expect(edd.day, 10);
    });

    test('calculateCurrentPregnancyWeek bounds checks within 1 and 40 weeks', () {
      final futureDate = DateTime.now().add(const Duration(days: 30));
      expect(GestationalCalculator.calculateCurrentPregnancyWeek(futureDate), 1);

      final ancientDate = DateTime.now().subtract(const Duration(days: 400));
      expect(GestationalCalculator.calculateCurrentPregnancyWeek(ancientDate), 40);

      final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));
      expect(GestationalCalculator.calculateCurrentPregnancyWeek(twoWeeksAgo), 2);
    });

    test('generateWHOSchedule returns the 8 mandatory WHO contacts', () {
      final lmp = DateTime(2026, 1, 1);
      final schedule = GestationalCalculator.generateWHOSchedule(lmp);

      expect(schedule.length, 8);
      expect(schedule.first['scheduled_week'], 12);
      expect(schedule.last['scheduled_week'], 40);
      expect(schedule.first['is_completed'], 0);
    });
  });

  group('SymptomLog Model Tests', () {
    test('toMap and fromMap correctly serialize and deserialize symptom logs', () {
      final log = SymptomLog(
        id: 1,
        loggedDate: '2026-09-15',
        weight: '65 kg',
        systolicBp: '120',
        diastolicBp: '80',
        symptomNotes: 'Feeling healthy, mild kicks felt.',
      );

      final map = log.toMap();
      expect(map['id'], 1);
      expect(map['logged_date'], '2026-09-15');
      expect(map['weight'], '65 kg');
      expect(map['systolic_bp'], '120');
      expect(map['diastolic_bp'], '80');
      expect(map['symptom_notes'], 'Feeling healthy, mild kicks felt.');

      final reconstructed = SymptomLog.fromMap(map);
      expect(reconstructed.id, log.id);
      expect(reconstructed.loggedDate, log.loggedDate);
      expect(reconstructed.weight, log.weight);
      expect(reconstructed.systolicBp, log.systolicBp);
      expect(reconstructed.diastolicBp, log.diastolicBp);
      expect(reconstructed.symptomNotes, log.symptomNotes);
    });
  });

  group('PdfExporter Tests', () {
    test('buildPdfDocument compiles valid PDF bytes without layout exceptions', () async {
      final sampleLogs = [
        {
          'logged_date': '2026-09-15',
          'weight': '65 kg',
          'systolic_bp': '120',
          'diastolic_bp': '80',
          'symptom_notes': 'Normal checkup, mild fatigue.',
        },
      ];

      final docWithLogs = await PdfExporter.buildPdfDocument('Mama Amina', sampleLogs);
      final bytesWithLogs = await docWithLogs.save();
      expect(bytesWithLogs.isNotEmpty, isTrue);

      // Verify empty logs state also compiles cleanly
      final emptyDoc = await PdfExporter.buildPdfDocument('Mama Amina', []);
      final emptyBytes = await emptyDoc.save();
      expect(emptyBytes.isNotEmpty, isTrue);
    });
  });

  group('App Smoke Test', () {
    testWidgets('SafeMomsApp mounts and renders onboarding screen when hasProfile is false', (WidgetTester tester) async {
      await tester.pumpWidget(const SafeMomsApp(hasProfile: false));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to SafeMoms'), findsOneWidget);
      expect(find.text('Your Full Name'), findsOneWidget);
      expect(find.text('Generate My Calendar'), findsOneWidget);
    });
  });
}
