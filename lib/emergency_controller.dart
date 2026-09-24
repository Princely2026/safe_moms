import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart'; // ✅ Verified stable version matching package mapping path
import 'database_helper.dart';

class EmergencyController {
  
  // Core Engine: Captures hardware GPS sensors and broadcasts a telephony SMS message
  static Future<bool> triggerEmergencyProtocol() async {
    String rescuePhoneNumber = "";
    
    try {
      // 1. Query local SQLite table to retrieve the pre-saved Next-of-Kin phone number
      final db = await DatabaseHelper.instance.database;
      final List<Map<String, dynamic>> userRows = await db.query('users', limit: 1);
      
      if (userRows.isNotEmpty) {
        rescuePhoneNumber = userRows.first['phone'].toString().trim();
      } else {
        debugPrint("SOS ERROR: No user profile or rescue contact found in local tables.");
        return false;
      }

      if (rescuePhoneNumber.isEmpty) {
        debugPrint("SOS ERROR: Rescue phone number is empty.");
        return false;
      }

      // 2. Hardware GPS Sensor Verification Checks
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position? position;
      if (serviceEnabled &&
          permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 10),
            ),
          );
        } catch (gpsError) {
          debugPrint("SOS GPS lock timed out or failed ($gpsError). Attempting last known position fallback...");
          try {
            position = await Geolocator.getLastKnownPosition();
          } catch (_) {}
        }
      }

      // 3. Format Emergency Message (with coordinates or fallback notice)
      String smsMessageBody;
      if (position != null) {
        String mapUrlLink = "https://maps.google.com/?q=${position.latitude},${position.longitude}";
        smsMessageBody = "EMERGENCY! Mom Needs urgent maternal care. Current location: $mapUrlLink";
      } else {
        smsMessageBody = "EMERGENCY! Mom Needs urgent maternal care. (GPS coordinates unavailable - please assist immediately!)";
      }

      // 4. Fire Telephony Carrier Intent to Broadcast the SMS Text Message
      String sendResult = await sendSMS(
        message: smsMessageBody,
        recipients: [rescuePhoneNumber],
      );
      
      debugPrint("SOS PROMPT STATUS: SMS intent dispatched successfully: $sendResult");
      return true;

    } catch (e) {
      debugPrint("SOS SYSTEM EXPORT EXCEPTION CRASH: $e");
      return false;
    }
  }
}

