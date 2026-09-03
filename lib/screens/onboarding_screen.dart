import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;

  //trigger the native andriod/ios calender overlay dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime maxPregnancyDuration = now.subtract(const Duration(days: 280));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: maxPregnancyDuration,
      lastDate: now,
      helpText: 'Select Last Menstrual Period (LMP)',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('SafeMoms  profile setup', style: TextStyle(fontWeight: FontWeight.bold,)),
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
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Welcome to SafeMoms',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Let\'s configure your data-free pregnancy companion.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 40),
                  
                //input 1: mothers name
                const Text('Your Full Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person, color: Colors.pinkAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter your name';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                  
                //input 2: emergency contact number
                const Text('Emergency Contact Number (MoMo / SMS)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'e.g., 677XXXXXX',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.phone, color: Colors.pinkAccent),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Please enter a rescue number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                //input 3: last menstrual period date selector
                const Text('First Day of Your Last Period (LMP)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null 
                              ? 'Tap to select date' 
                              : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 16, color: _selectedDate == null ? Colors.grey : Colors.black),
                        ),
                        const Icon(Icons.calendar_month, color: Colors.pinkAccent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                
                //submission button with screen navigation routing
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select your LMP date')),
                          );
                          return;
                        }
                        
                        // FIX: Kept logs and feedback cleanly bundled inside the execution workflow
                        print('Name: ${_nameController.text}');
                        print('Emergency Phone: ${_phoneController.text}');
                        print('LMP Selected: $_selectedDate');
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile created! Setting up offline database...'),
                          backgroundColor: Colors.green,
                        ),
                      );
                     }
                   },
                    child: const Text(
                      'Generate My Calendar',
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
