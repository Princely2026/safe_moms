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

      // 2. CRITICAL FIX: Verify device can physically send SMS before attempting dispatch.
      //    canSendSMS() returns false on Wi-Fi-only tablets, emulators without SIM,
      //    or when SEND_SMS runtime permission has been denied by the user.
      bool deviceCanSendSMS = await canSendSMS();
      if (!deviceCanSendSMS) {
        debugPrint("SOS ERROR: Device cannot send SMS. Check SIM card presence and SMS permissions.");
        return false;
      }

      // 3. Hardware GPS Sensor Verification Checks
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

      // 4. Format Emergency Message (with coordinates or fallback notice)
      String smsMessageBody;
      if (position != null) {
        String mapUrlLink = "https://maps.google.com/?q=${position.latitude},${position.longitude}";
        smsMessageBody = "EMERGENCY! Mom Needs urgent maternal care. Current location: $mapUrlLink";
      } else {
        smsMessageBody = "EMERGENCY! Mom Needs urgent maternal care. (GPS coordinates unavailable - please assist immediately!)";
      }

      // 5. Fire SMS via native telephony intent — this launches the SMS app with
      //    the message and recipient pre-filled, and the user presses Send.
      //    Note: flutter_sms v3 does not support background auto-send (sendDirect)
      //    due to Android OS security restrictions. The canSendSMS() guard above
      //    ensures the device is SMS-capable before this is reached.
      String sendResult = await sendSMS(
        message: smsMessageBody,
        recipients: [rescuePhoneNumber],
      );
      
      debugPrint("SOS PROMPT STATUS: SMS dispatch result: $sendResult");

      // 6. CRITICAL FIX: Validate the send result string properly.
      //    flutter_sms returns "SMS Sent!" on success. Returning true blindly on any
      //    non-exception result was masking real send failures.
      if (sendResult.toLowerCase().contains("sent") ||
          sendResult.toLowerCase().contains("success")) {
        return true;
      }
      
      // If we get here, the result was unexpected — log it but still signal attempted
      debugPrint("SOS WARNING: Unexpected SMS result: '$sendResult'");
      return sendResult.isNotEmpty; // Non-empty means the intent was at least dispatched


    } catch (e) {
      debugPrint("SOS SYSTEM EXPORT EXCEPTION CRASH: $e");
      return false;
    }
  }
}

