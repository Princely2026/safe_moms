import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database_helper.dart';

class LogSymptomScreen extends StatefulWidget {
  const LogSymptomScreen({super.key});

  @override
  State<LogSymptomScreen> createState() => _LogSymptomScreenState();
}

class _LogSymptomScreenState extends State<LogSymptomScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _weightController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Task: Take form values and commit them to Member 4's SQLite symptoms table
  Future<void> _submitDailyLog() async {
    if (_formKey.currentState!.validate()) {
      setState(() { _isSaving = true; });

      // Generate a clean current timestamp string (YYYY-MM-DD)
      final DateTime now = DateTime.now();
      final String formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

      try {
        await DatabaseHelper.instance.saveSymptomLog(
          formattedDate,
          _weightController.text.trim().isEmpty ? "N/A" : "${_weightController.text} kg",
          _systolicController.text.trim().isEmpty ? "N/A" : _systolicController.text,
          _diastolicController.text.trim().isEmpty ? "N/A" : _diastolicController.text,
          _notesController.text.trim().isEmpty ? "None" : _notesController.text.trim(),
        );

        debugPrint("SUCCESS: Vitals and health symptom notes written to SQLite data rows!");

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health metrics logged successfully offline!'),
            backgroundColor: Colors.green,
          ),
        );

        // Closes the modal or screen and returns back to the dashboard feed
        Navigator.pop(context);
      } catch (error) {
        setState(() { _isSaving = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save log: $error'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Log Daily Vitals', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Track Your Health Status',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'This data compiles directly into your doctor report.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),

                // Field 1: Current Weight (Numeric Only)
                const Text('Current Weight (kg) - Optional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: InputDecoration(
                    hintText: 'e.g., 68.5',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.scale, color: Colors.pinkAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final parsed = double.tryParse(value.trim());
                    if (parsed == null || parsed <= 0 || parsed > 300) {
                      return 'Please enter a valid weight in kg';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Blood Pressure Fields Container Block (Horizontal Row Layout)
                const Text('Blood Pressure (mmHg) - Optional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    // Systolic Box
                    Expanded(
                      child: TextFormField(
                        controller: _systolicController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          hintText: 'Systolic (e.g., 120)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return null;
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed < 40 || parsed > 300) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('/', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ),
                    // Diastolic Box
                    Expanded(
                      child: TextFormField(
                        controller: _diastolicController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          hintText: 'Diastolic (e.g., 80)',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) return null;
                          final parsed = int.tryParse(value.trim());
                          if (parsed == null || parsed < 30 || parsed > 200) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Field 3: General Symptom Condition Notes
                const Text('Symptom Notes & Physical Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Describe how you feel (e.g., mild nausea, swollen feet, or feeling completely healthy...)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 40),

                // Action Submission Button Container
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isSaving ? null : _submitDailyLog,
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Log Entry',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}